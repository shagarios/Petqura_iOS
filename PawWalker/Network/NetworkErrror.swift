//
//  NetworkErrror.swift
//  PawWalker
//
//  Created by shagar p k on 11/09/24.
//

import Foundation
import Alamofire

struct NetworkError : Error {
    
    let initialError : AFError?
    let backendError : BackendError?
}

struct BackendError : Codable, Error {
    let message : String
    let status : String?
}




