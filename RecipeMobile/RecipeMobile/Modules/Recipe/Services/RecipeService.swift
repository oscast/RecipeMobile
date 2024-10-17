//
//  RecipeService.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation
import Combine

class RecipeService: ObservableObject {
    
    let recipeService: Requester
    
    init(recipeService: Requester) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let endpoint = RecipeEndpoint()
        return try await recipeService.performRequest(endpoint: endpoint, responseModel: [Recipe].self)
    }
    
}
