//
//  AppError.swift
//  PawWalker
//
//  Created by shagar on 08/07/26.
//


import Foundation

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

    init(requestError: RequestError) {
       switch requestError {
         case .invalidURL:
            self = .invalidURL

        case .invalidResponse:
            self = .invalidResponse

        case .decodingFailed:
            self = .decodingFailed
            

        case .httpError(let statusCode):

            switch statusCode {

            case 401:
                self = .unauthorized

            case 403:
                self = .forbidden

            case 404:
                self = .notFound

            case 500:
                self = .serverError

            default:
                self = .unknown("HTTP Error \(statusCode)")
            }
       case .noInternet:
           self = .noInternet
       }
    }

    var errorDescription: String {

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
            return "Please enter valid mobile number"
        case .mobileValidationFailed:
            return "Please enter valid mobile number"
        }
    }
}
