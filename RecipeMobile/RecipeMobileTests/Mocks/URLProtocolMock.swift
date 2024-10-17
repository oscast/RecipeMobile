//
//  URLProtocolMock.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation
@testable import RecipeMobile

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let response = response else {
            throw NetworkError.unknownError
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw httpResponse.toNetworkError(data: data)
        }
        
        guard let data = data else {
            throw NetworkError.unknownError
        }
        
        return (data, response)
    }
}
