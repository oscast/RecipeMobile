//
//  RequestServiceTest.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import XCTest
@testable import RecipeMobile

class RequestServiceTests: XCTestCase {
    
    var requestService: RequestService!
    var mockSession: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        requestService = RequestService(session: mockSession)
    }
    
    override func tearDown() {
        requestService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testPerformRequest_SuccessfulResponse() async throws {
        // Arrange
        let jsonData = RecipesResponse.mockResponseData
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let endpoint = RecipeEndpoint()
        
        // Act
        let response: RecipesResponse = try await requestService.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
        
        print(response)
        // Assert
        XCTAssertEqual(response.recipes.count, 63)
        
        let american = response.recipes.filter { $0.cuisine == "American" }
        
        XCTAssertEqual(american.count, 14)
    }
    
    func testBadRequest_SuccessfulResponse() async throws {
        // Arrange
        let jsonData = RecipesResponse.mockMalformedData
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let endpoint = RecipeEndpoint()
        
        // Act
        let response: RecipesResponse = try await requestService.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
        
        print(response)
        // Assert
        XCTAssertEqual(response.recipes.count, 63)
        
        let american = response.recipes.filter { $0.cuisine == "American" }
        
        XCTAssertEqual(american.count, 14)
    }
    
//    func testPerformRequest_FailureResponse() async throws {
//        // Arrange
//        mockSession.data = nil
//        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
//                                               statusCode: 500,
//                                               httpVersion: nil,
//                                               headerFields: nil)
//        let endpoint = RecipeEndpoint()
//        
//        do {
//            // Act
//            let _: RecipesResponse = try await requestService.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
//            XCTFail("Expected to throw an error but succeeded.")
//        } catch {
//            // Assert
//            XCTAssertEqual(error as? NetworkError, NetworkError.serviceUnavailable)
//        }
//    }
}

// Mock URLSessionProtocol
class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw NetworkError.unknownError
        }
        return (data, response)
    }
}
