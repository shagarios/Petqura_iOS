//
//  ContentModel.swift
//  PawWalker
//
//  Created by shagar p k on 12/09/24.
//

import Foundation
struct PostElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

