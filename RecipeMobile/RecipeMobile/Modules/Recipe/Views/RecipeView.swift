//
//  RecipeView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI
import Kingfisher

struct RecipeView: View {
    
    @State var recipeSections: [RecipeSection] = []
    @State var requestError: Error?
    @ObservedObject var service = RecipeService()
    
    @State private var selectedURL: RecipeURL?
    @State private var imageURL: NavigationURL?
    
    var body: some View {
        ScrollView {
            if requestError != nil {
                Text(requestError?.localizedDescription ?? "")
            } else {
                LazyVStack(alignment: .leading) {
                    ForEach(recipeSections, id: \.id) { section in
                        RecipeSectionView(section: section, selectedURL: $selectedURL)
                    }
                }
                .padding()
            }
        }
        .refreshable {
            fetchRecipes()
        }
        .task {
            fetchRecipes()
        }
        .sheet(item: $selectedURL) { recipeURL in
            SafariView(url: recipeURL.url)
        }
    }
    
    func fetchRecipes() {
        Task {
            do {
                let recipes = try await service.fetchRecipes()
                
                await MainActor.run {
                    self.recipeSections = recipes
                }
            } catch {
                self.requestError = error
            }
        }
    }
}


struct RecipeSectionView: View {
    let section: RecipeSection
    @Binding var selectedURL: RecipeURL?
    
    var body: some View {
        Section(content: {
            ForEach(section.recipes) { recipe in
                RecipeRowView(recipe: recipe, selectedURL: $selectedURL)
            }
        }, header: {
            Text(section.sectionName)
                .foregroundStyle(Color.red)
        })
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    @Binding var selectedURL: RecipeURL?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(recipe.name)
                Spacer()
                KFImage(recipe.photoUrlSmall)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(11.0)
            }
            RecipeLinkView(recipe: recipe, selectedURL: $selectedURL)
            Divider()
        }
    }
}

struct RecipeLinkView: View {
    let recipe: Recipe
    @Binding var selectedURL: RecipeURL?
    
    var body: some View {
        HStack {
            if let website = recipe.sourceUrl {
                Button(action: {
                    selectedURL = RecipeURL(url: website)
                }) {
                    Text("Open Website")
                        .foregroundColor(.blue)
                        .underline()
                }
                Spacer()
                Divider()
                Spacer()
            }
            
            if let videoURL = recipe.youtubeUrl {
                Button(action: {
                    selectedURL = RecipeURL(url: videoURL)
                }) {
                    Text("Watch Video")
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct RecipeURL: Identifiable {
    var id: String {
        url.absoluteString
    }
    
    let url: URL
}

struct NavigationURL: Identifiable {
    var id: String {
        url.absoluteString
    }
    
    let url: URL
}

#Preview {
    RecipeView()
}
