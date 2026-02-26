//
//  Injection.swift
//  PawWalker
//
//  Created by shagar p k on 10/09/24.
//

import Foundation
import Swinject


final class Injection {
    static let shared = Injection()
    let container = Container()
    init() {
        container.register(DataParserProtocol.self) { _ in
            return DataParser()
        }
        container.register(ApiClientProtocol.self) { _ in
            return APIClient()
        }
        container.register(AnalyticsManagerProtocol.self) { _ in
            return AnalyticsManager(logger: FirbaseAnalyticsManager())
        }
        container.register(ProgressHudManagerProtocol.self) { _ in
            return ProgressHudManager(progressHud: ProgressHudNew())
        }
        container.register(EncryptionManagerProtocol.self) { _ in
            return EncryptionManager(encryption: AESManager())
        }
        container.register(CoreDataServiceProtocol.self) { _ in
            return CoreDataService()
        }
        container.register(NetworkMonitor.self) { _ in
            return AlamofireNetWorkMonitor()
        }
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue : Dependency
    init() {
        self.wrappedValue = Injection.shared.container.resolve(Dependency.self)!
    }
}
