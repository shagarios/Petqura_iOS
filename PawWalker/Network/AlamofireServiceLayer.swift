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
    @Injected var tokenStore : TokenStoreProtocol
    private lazy var authInterceptor = AuthInterceptor(tokenStore: tokenStore)
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
        // return try await withCheckedThrowingContinuation { continuation in
    //}
            let response =  await session
                           .request(endpoint.path,
                            method: endpoint.httpsMethod,parameters: parameters,
                            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
                            headers: headers,
                            interceptor: endpoint.authRequired ? authInterceptor : nil)
            .validate(statusCode: 200...299)
            .serializingDecodable(T.self)
            .response
        let result = response.result
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            let networkError = self.mapError(failure, response.data)
            throw networkError
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
        return tokenStore.accessToken ?? TextResource.empty
    }
}

