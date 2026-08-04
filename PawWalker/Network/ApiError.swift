//
//  ApiError.swift
//  PawWalker
//
//  Created by shagar p k on 10/09/24.
//

import Foundation

enum ApiError : LocalizedError {
    case invalidResponse
    case invalidURL
    case decondingError
    case unKnown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidURL:
            return "The URL is invalid."
        case .decondingError:
            return "There was a problem decoding the data."
        case .unKnown(let error):
            return error.localizedDescription
        }
    }
}

