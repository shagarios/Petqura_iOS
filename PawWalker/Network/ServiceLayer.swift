//
//  ServiceLayer.swift
//  PawWalker
//
//  Created by shagar on 13/06/26.
//

import Foundation

protocol ServiceLayerProtocol {
    func makeRequest<T:Decodable>(endpoint: Router,parameters: [String: Any]?) async throws -> T
}

extension ServiceLayerProtocol {
    func makeRequest<T:Decodable>(endpoint: Router,parameters: [String: Any]? = nil) async throws -> T {
        try await makeRequest(endpoint: endpoint,parameters: nil)
    }
}

class ApiServiceLayer : ServiceLayerProtocol {
    var  session : URLSession
    @Injected var coreDataService : CoreDataServiceProtocol
    init() {
        // ✅ Set config here, not inside makeRequest
        let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 30       // ✅ request timeout
                config.timeoutIntervalForResource = 60      // ✅ total resource timeout (download/upload)
                config.requestCachePolicy = .reloadIgnoringLocalCacheData  // ✅ always fresh data
                self.session = URLSession(configuration: config)
    }
    func makeRequest<T:Decodable>(endpoint: Router,parameters: [String: Any]? = nil) async throws -> T {
        var headers: [String: String] = [ApiParameters.contentType: Strings.contentTypeString]
        if endpoint.authRequired {
            let access = await fetchAccessToken()
            if !access.isEmpty {
                headers[ApiParameters.authorization] = Strings.bearer + access
            }
        }
             let request = try buildRequest(from: endpoint, header: headers,parameters: parameters)
             let (data, response) = try await session.data(for: request)
             guard let httpResponse = response as? HTTPURLResponse else {
                 throw RequestError.invalidResponse
             }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpError(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            throw RequestError.decodingFailed
        }
    }
    
    private func buildRequest(from endpoint: Router,header : [String: String],
                              parameters: [String: Any]?
    ) throws -> URLRequest {
            guard let url = URL(string: endpoint.path) else {
                throw RequestError.invalidURL
            }
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.httpMethod.rawValue
            request.allHTTPHeaderFields = header
            if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters,options: [])
            }
            return request
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



enum RequestError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingFailed
    case noInternet
}

enum HTTPSMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
