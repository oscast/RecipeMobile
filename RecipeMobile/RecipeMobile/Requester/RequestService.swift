//
//  RequestService.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

// MARK: - Requester Protocol

protocol Requester {
    func performRequest<T: Decodable>(with request: URLRequest) async throws -> T
}

// MARK: - RequestService Class

class RequestService: Requester {
    
    private let session: URLSession
    
    // Dependency Injection of URLSession, allowing for mock sessions during testing
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Perform request using a generic return type and URLRequest injection
    func performRequest<T: Decodable>(with request: URLRequest) async throws -> T {
        do {
            // Make the network request using async/await
            let (data, response) = try await session.data(for: request)
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            // Decode the JSON response into the expected generic type
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            
            return decodedObject
            
        } catch {
            // Handle and propagate any errors
            throw error
        }
    }
}
