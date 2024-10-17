//
//  RecipeService.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation
import Combine

class RecipeService: ObservableObject {
    
    let recipeRequester: Requester
    
    init(recipeRequester: Requester = RequestService()) {
        self.recipeRequester = recipeRequester
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let endpoint = RecipeEndpoint()
        let recipes = try await recipeRequester.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
        return recipes.recipes
    }
    
}
