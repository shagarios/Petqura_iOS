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
        container.register(ServiceLayerProtocol.self) { _  in
            return ServiceLayer()
        }
        container.register(HomeRepository.self) { _ in
            return HomeRepositoryImplementation()
        }
        container.register(ProductCartUseCaseProtocol.self) { _ in
            return ProductCartUseCase()
        }
        container.register(ProductRepository.self) { _ in
            return ProductRepositoryImplementation()
        }
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue : Dependency
    init() {
        self.wrappedValue = Injection.shared.container.resolve(Dependency.self)!
    }
}
