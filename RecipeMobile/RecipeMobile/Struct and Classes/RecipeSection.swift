//
//  RecipeSection.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

struct RecipeSection: Identifiable {
    var id: String {
        sectionName
    }
    
    let sectionName: String
    let recipes: [Recipe]
}
