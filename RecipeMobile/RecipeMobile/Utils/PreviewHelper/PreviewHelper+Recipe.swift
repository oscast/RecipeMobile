//
//  PreviewHelper.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

extension RecipesResponse {
    
    static var mockResponseData: Data {
        PreviewHelper.loadJSONData(filename: "recipes") ?? Data()
    }
    
    static var mockMalformedData: Data {
        PreviewHelper.loadJSONData(filename: "malformed") ?? Data()
    }


}
