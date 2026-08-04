//
//  ErrorHandler.swift
//  PawWalker
//
//  Created by shagar on 13/06/26.
//

import Foundation
// MARK: - Protocol
protocol ErrorHandable {
  //  func handleRequestError(_ error: RequestError)
    func showError(_ message: String)
}

// MARK: - Default Implementation
extension ErrorHandable {
//    func handleRequestError(_ error: AppError) {
//        switch error {
//            
//        case .invalidURL:
//            showError("Invalid URL")
//
//        case .invalidResponse:
//            showError("Invalid server response")
//
//
//        case .decodingFailed:
//            showError("Failed to process response")
//
//        case .noInternet:
//            <#code#>
//        case .unauthorized:
//            <#code#>
//        case .forbidden:
//            <#code#>
//        case .notFound:
//            <#code#>
//        }
//    }
    
    // MARK: - Default Toast Implementation
    func showError(_ message: String) {
        ToastCenter.shared.showToast(message, type: .error)
    }

    // MARK: - HTTP Error Handler
    private func handleHTTPError(_ statusCode: Int) {
        switch statusCode {
        case 401:
            showError("Session expired. Please login again")
            handleUnauthorized()
        case 403:
            showError("Access denied")
        case 404:
            showError("Resource not found")
        case 500:
            showError("Server error. Try again later")
        default:
            showError("HTTP Error: \(statusCode)")
        }
    }

    // MARK: - Override in ViewModel if needed
    func handleUnauthorized() {
        // Default: do nothing
        // Override in ViewModel to navigate to login
    }
}
