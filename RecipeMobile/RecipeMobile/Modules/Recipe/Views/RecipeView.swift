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
    
    @State private var selectedURL: NavigationURL?
    @State private var selectedImageURL: NavigationURL?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if requestError != nil {
                    VStack(alignment: .center) {
                        Spacer()
                        Text(requestError?.localizedDescription ?? "")
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .padding(.vertical)
                        
                        Image(systemName: "text.page.badge.magnifyingglass")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    .padding()
                } else {
                    
                    if recipeSections.isEmpty {
                        
                    } else {
                        LazyVStack(alignment: .leading) {
                            ForEach(recipeSections, id: \.id) { section in
                                RecipeSectionView(section: section, selectedURL: $selectedURL, selectedImageURL: $selectedImageURL)
                            }
                        }
                        .padding()
                    }
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
            .fullScreenCover(item: $selectedImageURL) { imageURL in
                NavigationStack {
                    FullScreenImageView(imageURL: imageURL.url)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    selectedImageURL = nil
                                }
                            }
                        }
                }
            }
            .navigationTitle("Recipes")
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

extension RecipeView {
    
    struct RecipeSectionView: View {
        let section: RecipeSection
        @Binding var selectedURL: NavigationURL?
        @Binding var selectedImageURL: NavigationURL?
        
        var body: some View {
            Section(content: {
                ForEach(section.recipes) { recipe in
                    RecipeRowView(recipe: recipe, selectedURL: $selectedURL, selectedImageURL: $selectedImageURL)
                        .padding(.bottom)
                }
            }, header: {
                Text(section.sectionName)
                    .font(.system(size: 22).weight(.bold))
            })
        }
    }
    
    struct RecipeRowView: View {
        let recipe: Recipe
        @Binding var selectedURL: NavigationURL?
        @Binding var selectedImageURL: NavigationURL?
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(recipe.name)
                    Spacer()
                    KFImage(recipe.photoUrlSmall)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(11.0)
                        .onTapGesture {
                            selectedImageURL = NavigationURL(url: recipe.photoUrlLarge)
                        }
                }
                
                RecipeLinkView(recipe: recipe, selectedURL: $selectedURL)
                Divider()
            }
        }
    }
    
    struct RecipeLinkView: View {
        let recipe: Recipe
        @Binding var selectedURL: NavigationURL?
        
        var body: some View {
            HStack {
                if let website = recipe.sourceUrl {
                    Button(action: {
                        selectedURL = NavigationURL(url: website)
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
                        selectedURL = NavigationURL(url: videoURL)
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
    
}
