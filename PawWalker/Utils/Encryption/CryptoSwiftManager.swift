//
//  CryptoSwiftManager.swift
//  PawWalker
//
//  Created by shagar on 14/11/24.
//
import CryptoSwift
import Foundation

class CryptoSwiftManager  : EncryptionProtocol {
    func initilize() {
        
    }
    
    func encrypt(key: String, value: String) -> String? {
        // Convert key to bytes and set the IV to the first 16 bytes
           let keyData = Array(key.utf8)
           let ivData = Array(keyData.prefix(16))  // IV is the first 16 bytes of the key
           
           // Ensure key length is appropriate for AES (16, 24, or 32 bytes for AES-128, AES-192, AES-256)
           guard keyData.count == 16 || keyData.count == 24 || keyData.count == 32 else {
               print("Invalid key length")
               return nil
           }
           
           // Pad the plain text to match AES block size
        let paddedText = pad(plainText: value)
           guard let plainData = paddedText.data(using: .utf8) else {
               return nil
           }
           
           // Encrypt using AES-CBC mode
           do {
               let aes = try AES(key: keyData, blockMode: CBC(iv: ivData), padding: .pkcs7)
               let encryptedBytes = try aes.encrypt(plainData.bytes)
               
               // Encode the result to base64 for easy handling
               let encryptedData = Data(encryptedBytes)
               return encryptedData.base64EncodedString()
           } catch {
               print("Encryption error: \(error)")
               return nil
           }
    }
    
    func pad(plainText: String) -> String {
        let blockSize = 16
        let padding = blockSize - (plainText.count % blockSize)
        return plainText + String(repeating: Character(UnicodeScalar(padding)!), count: padding)
    }
}
