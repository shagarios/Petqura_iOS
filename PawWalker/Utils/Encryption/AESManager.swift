//
//  AESManager.swift
//  PawWalker
//
//  Created by shagar on 14/11/24.
//

import AesEverywhere
import Foundation

class AESManager : EncryptionProtocol {
    func initilize() {
        
    }
    func encrypt(key: String, value: String) -> String? {
        do {
            let crypted = try AES256.encrypt(input: value, passphrase: key)
            print("encryption : \(crypted)")
            let value = try AES256.decrypt(input: crypted, passphrase: key)
            print("decription : \(value)")
            return crypted
        }
        catch {
            return nil
        }
    }
}
