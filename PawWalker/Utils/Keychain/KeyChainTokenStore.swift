//
//  KeyChainTokenStore.swift
//  PawWalker
//
//  Created by shagar on 13/10/26.
//

import Foundation

protocol TokenStoreProtocol {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var isLoggedIn: Bool { get }
    func save(accessToken: String, refreshToken: String) throws
    func updateAccessToken(_ token: String) throws
    func clear() throws
}

final class KeychainTokenStore: TokenStoreProtocol {

    private enum Key {
        static let access = "auth.accessToken"
        static let refresh = "auth.refreshToken"
    }

    private let keychain: KeychainStore

    init(keychain: KeychainStore = KeychainStore()) {
        self.keychain = keychain
    }

    var accessToken: String? { keychain.get(Key.access) }
    var refreshToken: String? { keychain.get(Key.refresh) }
    var isLoggedIn: Bool { !(accessToken ?? "").isEmpty }

    func save(accessToken: String, refreshToken: String) throws {
        try keychain.set(accessToken, for: Key.access)
        try keychain.set(refreshToken, for: Key.refresh)
    }

    func updateAccessToken(_ token: String) throws {
        try keychain.set(token, for: Key.access)
    }

    func clear() throws {
        try keychain.remove(Key.access)
        try keychain.remove(Key.refresh)
    }
}
