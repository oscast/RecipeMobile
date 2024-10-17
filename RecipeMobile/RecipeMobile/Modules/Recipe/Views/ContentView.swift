//
//  ContentView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var recipes: [Recipe] = []
    @ObservedObject var service = RecipeService()
    
    var body: some View {
        VStack {
            ForEach(recipes, id: \.id) { recipe in
                Text(recipe.name)
            }
        }
        .padding()
        .task({
            do {
                self.recipes = try await service.fetchRecipes()
            } catch {
                print("OH NOOO \(error)")
            }
        })
    }
}

#Preview {
    ContentView()
}
