//
//  ConfigurationManager.swift
//  PawWalker
//
//  Created by shagar on 29/10/24.
//

enum ConfigurationManager {
    enum Environment {
        case dev
        case prod
    }
    static var environment : Environment {
#if DEV
        return .dev
#elseif PROD
        return .prod
#endif
    }
}
