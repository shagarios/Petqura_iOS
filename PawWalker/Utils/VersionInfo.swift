//
//  VersionInfo.swift
//  Flashat
//
//  Created by Sujith Thankachan on 24/02/23.
//  Copyright © 2023 Flashat. All rights reserved.
//

import Foundation

struct VersionInfo: Codable {
    let appInfo: AppVersionInfo
    let showMapInfo : MapInfo
    
    enum CodingKeys: String, CodingKey {
        case appInfo = "ios_app_version_info"
        case showMapInfo = "show_map_info"
    }
}

struct AppVersionInfo: Codable {
    let version: String
    let appStoreUrl: String
    let canSkip: Bool
    let showPopUp: Bool
}

struct MapInfo : Codable {
    let showMapScreen : Bool
}
