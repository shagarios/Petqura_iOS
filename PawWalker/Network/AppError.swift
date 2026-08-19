//
//  AppError.swift
//  PawWalker
//
//  Created by shagar on 08/07/26.
//


import Foundation
import Alamofire

import Alamofire

enum AppError: LocalizedError {

    case noInternet
    case invalidURL
    case invalidResponse
    case decodingFailed
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown(String)
    case emailValidationFailed
    case mobileValidationFailed

    init(afError: AFError) {
        // Check for "no internet" first — it usually comes wrapped
        // inside .sessionTaskFailed as a URLError.
        if case let .sessionTaskFailed(error) = afError,
           let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet {
            self = .noInternet
            return
        }

        // AFError gives you a convenience `.responseCode` that pulls
        // the HTTP status code out of whichever case produced it
        // (responseValidationFailed, responseSerializationFailed, etc.)
        if let statusCode = afError.responseCode {
            switch statusCode {
            case 401:
                self = .unauthorized
            case 403:
                self = .forbidden
            case 404:
                self = .notFound
            case 500...599:
                self = .serverError
            default:
                self = .unknown("HTTP Error \(statusCode)")
            }
            return
        }

        switch afError {
        case .invalidURL:
            self = .invalidURL

        case .responseSerializationFailed:
            self = .decodingFailed

        case .responseValidationFailed:
            self = .invalidResponse

        default:
            self = .unknown(afError.localizedDescription)
        }
    }

    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No Internet Connection"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .decodingFailed:
            return "Failed to decode response"
        case .unauthorized:
            return "Session expired"
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "Resource not found"
        case .serverError:
            return "Server Error"
        case .unknown(let message):
            return message
        case .emailValidationFailed:
            return "Please enter a valid email"
        case .mobileValidationFailed:
            return "Please enter valid mobile number"
        }
    }
}
