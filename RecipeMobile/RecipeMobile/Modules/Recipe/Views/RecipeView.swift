//
//  RecipeView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI
import Kingfisher

struct RecipeView: View {
    
    // MARK: - View attributes
    @ObservedObject var service = RecipeService()
    
    @State var recipeSections: [RecipeSection] = []
    @State var requestError: Error?
    @State private var selectedURL: NavigationURL?
    @State private var selectedImageURL: NavigationURL?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if requestError != nil {
                    EventStateView(text: requestError?.localizedDescription ?? "", imageName: "text.page.badge.magnifyingglass")
                } else {
                    
                    if recipeSections.isEmpty {
                        EventStateView(text: "Sorry, We couldn't find some recipes for you.", imageName: "carrot")
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

// MARK: - RecipeView Extension

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
