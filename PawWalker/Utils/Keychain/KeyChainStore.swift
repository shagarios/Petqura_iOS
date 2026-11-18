//
//  KeyChainStore.swift
//  PawWalker
//
//  Created by shagar on 13/10/26.
//

import Foundation
import Security

enum KeychainError: Error {
    case encodingFailed
    case unexpectedStatus(OSStatus)
}

/// Minimal wrapper around the Security framework for storing small secrets as strings.
struct KeychainStore {

    /// Namespaces every item so they do not collide with other apps or libraries.
    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? "com.app.petqura") {
        self.service = service
    }

    // The three attributes that uniquely identify one item.
    private func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }

    /// Insert or overwrite a value.
    func set(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            // Readable once the user has unlocked the device at least once since boot,
            // which lets a background token refresh work. "ThisDeviceOnly" stops the item
            // from being restored onto a different device via backup or iCloud Keychain.
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        // Try to update an existing item first.
        let updateStatus = SecItemUpdate(baseQuery(for: key) as CFDictionary,
                                         attributes as CFDictionary)

        switch updateStatus {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            // Nothing to update, so add a new item.
            var addQuery = baseQuery(for: key)
            attributes.forEach { addQuery[$0.key] = $0.value }
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.unexpectedStatus(addStatus)
            }
        default:
            throw KeychainError.unexpectedStatus(updateStatus)
        }
    }

    /// Read a value. Returns nil when the item does not exist.
    func get(_ key: String) -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// Delete a value. Deleting something that is already gone is not an error.
    func remove(_ key: String) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
