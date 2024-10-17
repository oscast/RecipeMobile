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
    
    func fetchRecipes() async throws -> [RecipeSection] {
        let endpoint = RecipeEndpoint()
        let response = try await recipeRequester.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
        let sections = makesRecipeSections(for: response.recipes)
        
        return sections
    }
    
    func makesRecipeSections(for recipes: [Recipe]) -> [RecipeSection] {
        let sectionNames = Set(recipes.map { $0.cuisine })
        
        let recipeSections = sectionNames.map { sectionName in
            RecipeSection(sectionName: sectionName, recipes: recipes.filter({ $0.cuisine == sectionName }))
        }
        
        return recipeSections
    }
    
}
