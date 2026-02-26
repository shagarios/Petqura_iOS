//
//  EncryptionManager.swift
//  PawWalker
//
//  Created by shagar on 11/11/24.
//

import Foundation

protocol EncryptionProtocol {
    func initilize()
    func encrypt(key : String, value : String) -> String?
}

protocol EncryptionManagerProtocol {
    func encrypt(key : String, value : String) -> String?
}


class EncryptionManager : EncryptionManagerProtocol {
   
    let encryption : EncryptionProtocol
    init(encryption : EncryptionProtocol) {
        self.encryption = encryption
    }
    func encrypt(key: String, value: String) -> String? {
        encryption.encrypt(key: key, value: value)
    }
    
    
}
