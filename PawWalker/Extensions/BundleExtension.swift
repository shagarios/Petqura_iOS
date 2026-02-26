//
//  BundleExtension.swift
//  PawWalker
//
//  Created by shagar on 29/10/24.
//

import Foundation

extension Bundle {
    var apiBaseUrl : String {
        return object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    }
    var googleMapKey : String {
        return object(forInfoDictionaryKey: "GOOGLE_MAP_KEY") as? String ?? ""
    }
    var appVersion : String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    var scheme: String {
        return object(forInfoDictionaryKey: "INSTANCE") as? String ?? ""
    }
}

