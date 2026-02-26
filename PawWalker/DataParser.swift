//
//  DataParser.swift
//  PawWalker
//
//  Created by shagar p k on 10/09/24.
//

import Foundation

protocol DataParserProtocol {
    func decode<T: Decodable>(data: Data,type : T) -> Result<T,ApiError>
}


class DataParser : DataParserProtocol {
    func decode<T: Decodable>(data: Data,type : T) -> Result<T,ApiError> {
        do{
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        }
        catch {
            return .failure(.decondingError)
        }
    }
}
