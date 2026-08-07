//
//  AlamofireServiceLayer.swift
//  PawWalker
//
//  Created by shagar on 13/06/26.
//

import Alamofire
import Foundation

class ServiceLayer: ServiceLayerProtocol {
    // MARK: - Properties
    private let session: Session
    @Injected var coreDataService : CoreDataServiceProtocol
    // MARK: - Init
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        // ✅ SSL Pinning
//        let serverTrustManager = ServerTrustManager(evaluators: [
//            "api.yourapp.com": PinnedCertificatesTrustEvaluator()
//        ])
//        
//        self.session = Session(configuration: config,
//                               serverTrustManager: serverTrustManager)
        self.session = Session(configuration: config)
    }
    
    // MARK: - Regular Request
    func makeRequest<T: Decodable>(endpoint: Router,parameters: [String: Any]?) async throws -> T {
        var headers: HTTPHeaders = [ApiParameters.contentType: Strings.contentTypeString]
        if endpoint.authRequired {
            let access = await fetchAccessToken()
            if !access.isEmpty {
                headers[ApiParameters.authorization] = Strings.bearer + access
            }
        }
        return try await withCheckedThrowingContinuation { continuation in
            session.request(endpoint.path,
                            method: endpoint.httpsMethod,parameters: parameters,
                            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
                            headers: headers)
            .validate(statusCode: 200...299)
            .responseDecodable(of: T.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    let networkError = self.mapError(error, response.data)
                    continuation.resume(throwing: networkError)
                }
            }
        }
    }
    private func mapError(_ error: AFError, _ data: Data?) -> NetworkError {
        // MARK: - Parse Backend Error if data exists
        let backendError = data.flatMap {
            try? JSONDecoder().decode(BackendError.self, from: $0)
        }
        return NetworkError(initialError: error, backendError: backendError)
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
}

