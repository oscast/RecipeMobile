//
//  RecipeEndpoint.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

struct RecipeEndpoint: Endpoint {
    var baseURL: URL { .cloudFront }
    var path: String { "recipes.json" }
    var method: HTTPMethod { .get }
    var headers: [String: String]?
    var queryParams: [String: String]?
    var body: Data?
}
