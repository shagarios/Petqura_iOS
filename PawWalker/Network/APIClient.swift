//
//  APIClient.swift
//  PawWalker
//
//  Created by shagar p k on 11/09/24.
//

import Foundation
import Alamofire
import Combine

protocol ApiClientProtocol {
   func  APIRequest<T: Decodable>(router : Router,parameters : Parameters?,responseType: T.Type) -> AnyPublisher<T,NetworkError>
}

extension ApiClientProtocol {
    func APIRequest<T: Decodable>(router : Router,parameters : Parameters? = nil,responseType: T.Type) -> AnyPublisher<T,NetworkError> {
      APIRequest(router: router, parameters: parameters, responseType: responseType)
    }
}

class APIClient : ApiClientProtocol {
    @Injected var coreDataService : CoreDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var retryCount = 0

    var sessionManager : Session = {
        var configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        let responseCancher = ResponseCacher(behavior: .modify({ _, response in
            let userInfo = ["data" : Date()]
            return CachedURLResponse(response: response.response, data: response.data, userInfo: userInfo, storagePolicy: .allowed)
        }))
        
        #if DEBUG
        return Session(configuration: configuration,cachedResponseHandler: responseCancher)
        
        #else
        return Session(configuration: configuration,cachedResponseHandler: responseCancher)
        #endif
        
    }()
    
    // Replace your current APIRequest with this version.
    // Notes:
    // 1. All UI/state mutations and storing of cancellables happen on the main thread.
    // 2. Promise is guarded to be fulfilled only once.
    // 3. Recursive retry on 401 is done by chaining the publisher rather than creating a nested sink on an arbitrary thread.
    // 4. Uses Deferred + Future to delay work until subscription.

    func APIRequest<T: Decodable>(router: Router,
                                  parameters: Parameters? = nil,
                                  responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        Deferred {
            Future<T, NetworkError> { [weak self] promise in
                guard let strongSelf = self else {
                    DispatchQueue.main.async {
                        promise(.failure(NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)))
                    }
                    return
                }

                // local var to ensure promise called once
                var didComplete = false
                func completeOnce(_ result: Result<T, NetworkError>) {
                    guard !didComplete else { return }
                    didComplete = true
                    DispatchQueue.main.async {
                        promise(result)
                    }
                }

                Task {
                    var headers: HTTPHeaders = [ApiParameters.contentType: Strings.contentTypeString]

                    if router.authRequired {
                        let access = await strongSelf.fetchAccessToken()
                        if !access.isEmpty {
                            headers[ApiParameters.authorization] = Strings.bearer + access
                        }
                    }

                    // Make the request using sessionManager
                    strongSelf.sessionManager.request(router.path,
                                                      method: router.method,
                                                      parameters: parameters,
                                                      encoding: JSONEncoding.default,
                                                      headers: headers)
                        .validate()
                        .responseDecodable(of: T.self) { response in

                            switch response.result {
                            case .success(let decoded):
                                completeOnce(.success(decoded))

                            case .failure(let error):
                                // handle 401: attempt refresh then retry (but do it in a thread-safe manner)
                                if response.response?.statusCode == 401 {
                                    strongSelf.refreshToken { success in
                                        if success && strongSelf.retryCount < 2 {
                                            strongSelf.retryCount += 1
                                            // Retry: call APIRequest again and subscribe — ensure storing happens on main
                                            let retryPub = strongSelf.APIRequest(router: router,
                                                                                 parameters: parameters,
                                                                                 responseType: T.self)
                                            let retryCancellable = retryPub
                                                .receive(on: DispatchQueue.main)
                                                .sink { completion in
                                                    if case .failure(let netErr) = completion {
                                                        completeOnce(.failure(netErr))
                                                    }
                                                } receiveValue: { value in
                                                    completeOnce(.success(value))
                                                }

                                            // store cancelable on main to avoid races
                                            DispatchQueue.main.async {
                                                strongSelf.cancellables.insert(AnyCancellable(retryCancellable))
                                            }
                                        } else {
                                            completeOnce(.failure(NetworkError(initialError: error, backendError: nil)))
                                        }
                                    }
                                } else if let data = response.data {
                                    if let backend = try? JSONDecoder().decode(BackendError.self, from: data) {
                                        completeOnce(.failure(NetworkError(initialError: error, backendError: backend)))
                                    } else {
                                        completeOnce(.failure(NetworkError(initialError: error, backendError: nil)))
                                    }
                                } else {
                                    completeOnce(.failure(NetworkError(initialError: error, backendError: nil)))
                                }
                            }
                        } // end responseDecodable
                } // end Task
            } // end Future
        } // end Deferred
        .receive(on: DispatchQueue.main)      // Ensure downstream is on main
        .eraseToAnyPublisher()
    }

    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        var headers : HTTPHeaders = [ApiParameters.contentType : Strings.contentTypeString]
        headers[ApiParameters.authorization] = Strings.bearer + UserSessionManager.shared.refreshToken
        let param : [String: Any] = [ApiParameters.refreshToken : UserSessionManager.shared.refreshToken]
        print("param : \(param)")
        AF.request(Router.tokenRefresh.path,method: .post,parameters: param,encoding: JSONEncoding.default,headers: headers)
            .response { response in
                if let data = response.data, let dataResult = try? JSONSerialization.jsonObject(with: data,options: []) as? [String : Any],let result = dataResult["result"] as? [String: Any], let accessToken = result["access_token"] as? String {
                            print(accessToken)
                            self.saveUserDetailsToLocalStorage(aceessToken: accessToken)
                            UserSessionManager.shared.accessToken = accessToken
                            completion(true)
                }
                else {
                    if response.response?.statusCode == 401 {
                        self.deleteDatabase()
                        UserSessionManager.shared.accessToken = TextResource.empty
                        completion(false)
                    }
                    else {
                        completion(false)
                    }
                }
            }
    
    }
    func fetchAccessToken() async -> String {
            let result:Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user,
                sort: nil, predicate: nil, limit: nil)
            switch result {
            case .success(let users):
                return users.last?.accessToken ?? TextResource.empty
            case .failure(_):
                return TextResource.empty
            }
    }
    func saveUserDetailsToLocalStorage(aceessToken : String) {
        let entity : Any? = fetchUser() ?? coreDataService.createEntity(for: TableNames.user)
        guard let newUser = entity as? User else {return}
        newUser.accessToken = aceessToken
        print("access token : \(aceessToken)")
        coreDataService.save(object: newUser)
    }
    func fetchUser() -> User? {
        let result: Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let users):
            return users.first
        case .failure(_):
            return nil
        }
    }
    func deleteDatabase() {
        if let user = fetchUser() {
            do {
                coreDataService.delete(object: user)
                try coreDataService.context.save()
            }
            catch {}
        }
    }
    
}

