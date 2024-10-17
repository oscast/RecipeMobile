//
//  ContentView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State var recipeSections: [RecipeSection] = []
    @State var requestError: Error?
    @ObservedObject var service = RecipeService()
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(recipeSections, id: \.id) { section in
                    Section(content: {
                        ForEach(section.recipes) { recipe in
                            HStack {
                                Text(recipe.name)
                                Spacer()
                                KFImage(recipe.photoUrlSmall)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(11.0)
                            }
                            
                            if let website = recipe.sourceUrl {
                                Text("Website: \(website)")
                            }
                            
                            Divider()
                        }
                    }, header: {
                        Text(section.sectionName)
                            .foregroundStyle(Color.red)
                    })

                }
            }
            .padding()
        }

        .task({
            do {
                self.recipeSections = try await service.fetchRecipes()
            } catch {
            
            }
        })
    }
}

#Preview {
    ContentView()
}
