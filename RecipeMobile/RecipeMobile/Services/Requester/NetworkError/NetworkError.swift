//
//  NetworkError.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension HTTPURLResponse {
    func toNetworkError(data: Data? = nil) -> NetworkError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthenticated
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500:
            return .internalServerError
        case 503:
            return .serviceUnavailable
        default:
            if let data = data, let message = String(data: data, encoding: .utf8) {
                return .other(message)
            }
            return .unknownError
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case badRequest
    case unauthorized
    case notFound
    case forbidden
    case decodeFailed
    case unauthenticated
    case internalServerError
    case serviceUnavailable
    case unknownError
    case other(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .badRequest:
            return "Request is not correct"
        case .unauthenticated:
            return "Sorry, you are not authenticated"
        case .decodeFailed:
            return "Failed to decode the response data"
        case .unauthorized:
            return "Sorry, you are not authorized to see this information"
        case .notFound:
            return "The request path was not found"
        case .forbidden:
            return "Error, forbidden access"
        case .internalServerError:
            return "Internal Server Error"
        case .serviceUnavailable:
            return "serviceUnavailable"
        case .unknownError:
            return "unknownError"
        case .other(let message):
            return "Something ocurred \(message)"
        }
    }
}

