//
//  RequestService.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - Requester Protocol

protocol Requester {
    func performRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

// MARK: - RequestService Class

class RequestService: Requester {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw httpResponse.toNetworkError(data: data)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedObject = try decoder.decode(T.self, from: RecipesResponse.mockMalformedData)
                return decodedObject
            } catch {
                throw NetworkError.decodeFailed
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.other(error.localizedDescription)
        }
    }
}
