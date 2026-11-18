//
//  AuthInterceptor.swift
//  PawWalker
//
//  Created by shagar on 13/10/26.
//


import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {
    private let tokenStore: TokenStoreProtocol

    init(tokenStore: TokenStoreProtocol) {
        self.tokenStore = tokenStore
    }

    // 1. Before each send: attach the current token.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if let token = tokenStore.accessToken, token.isNotEmpty {
            request.setValue(Strings.bearer + token, forHTTPHeaderField: ApiParameters.authorization)
        }
        completion(.success(request))
    }


    func retry(_ request: Request, for session: Session,
               dueTo error: any Error, completion: @escaping (RetryResult) -> Void)  {
        guard request.response?.statusCode == 401, request.retryCount == 0 else {
            completion(.doNotRetry)
            return
        }
        refreshToken { success in
            completion(success ? .retry : .doNotRetryWithError(error))
        }
          
    }
    // 3. The refresh call itself. Uses `AF` (no interceptor) so it can never loop.
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refresh = tokenStore.refreshToken, !refresh.isEmpty else {
            logout(); completion(false); return
        }

        let headers: HTTPHeaders = [ApiParameters.contentType: Strings.contentTypeString,
                                    ApiParameters.authorization: Strings.bearer + refresh]

        AF.request(Router.tokenRefresh.path,
                   method: .post,
                   parameters: [ApiParameters.refreshToken: refresh],
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate(statusCode: 200...299)
        .responseDecodable(of: RefreshResponse.self) { [weak self] response in
            switch response.result {
            case .success(let body):
                try? self?.tokenStore.updateAccessToken(body.result.accessToken)
                completion(true)
            case .failure:
                if response.response?.statusCode == 401 { self?.logout() }
                completion(false)
            }
        }
    }

    private func logout() {
        try? tokenStore.clear()
        DispatchQueue.main.async {
            UserSessionManager.shared.accessToken = ""
            UserSessionManager.shared.refreshToken = ""
        }
    }
}

// { "result": { "access_token": "..." } }
private struct RefreshResponse: Decodable {
    struct Result: Decodable {
        let accessToken: String
        enum CodingKeys: String, CodingKey { case accessToken = "access_token" }
    }
    let result: Result
}
