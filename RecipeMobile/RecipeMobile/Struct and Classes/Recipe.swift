//
//  Recipe.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: URL
    let photoUrlSmall: URL
    let sourceUrl: URL?
    let uuid: String
    let youtubeUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case uuid
        case youtubeUrl = "youtube_url"
    }
}
