//
//  BlogListModel.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import SwiftUI

struct BlogListModel :  Codable {
    let message: String
    let result : BlogResult?
}

struct BlogResult : Codable {
    let blogs: [Blog]
}

struct Blog: Codable {
    let blogID: String
    let content: String?
    let image1: String
    let status: Bool
    let timeCreated, timeUpdated, title: String
    enum CodingKeys: String, CodingKey {
        case blogID = "blog_id"
        case content
        case image1, status
        case timeCreated = "time_created"
        case timeUpdated = "time_updated"
        case title
    }
}
