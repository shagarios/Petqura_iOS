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

    var id: Int {
        internalId ?? UUID().hashValue
    }

    let internalId: Int?
    let name: String
    let type: String?

    let subcategories: [FilterItem]?
    let items: [FilterItem]?

    enum CodingKeys: String, CodingKey {
        case internalId = "id"
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

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = "\(intId)"
        } else {
            id = try container.decode(String.self, forKey: .id)
        }

        name = try container.decode(String.self, forKey: .name)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
