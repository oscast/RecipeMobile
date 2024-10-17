//
//  NavigationURL.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

struct NavigationURL: Identifiable {
    var id: String {
        url.absoluteString
    }
    
    let url: URL
}
