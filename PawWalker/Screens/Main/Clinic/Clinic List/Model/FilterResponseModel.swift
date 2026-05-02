//
//  FilterResponseModel.swift
//  PawWalker
//
//  Created by Sathya S on 25/02/26.
//

import Foundation

struct FilterResponse: Codable {
    let message: String?
    let result: FilterResult?
}

struct FilterResult: Codable {
    let filters: [FilterType]
}


struct FilterType: Codable, Identifiable {
    let id: String?
    let name: String?
    let type: String?
    var subcategories: [FilterItem]?
    let items: [FilterItem]?
    var hasDot: Bool = false
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case subcategories
        case items
    }

    /// unified list for UI
    var displayItems: [FilterItem] {
        subcategories ?? items ?? []
    }
}


struct FilterItem: Codable, Identifiable, Hashable {
    let id: String?
    let name: String?
    var category : String = ""
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
