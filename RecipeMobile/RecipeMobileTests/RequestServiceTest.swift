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
        
        do {
            let _: RecipesResponse = try await requestService.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
        } catch {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error.localizedDescription, "Sorry, the data you are trying to see may be corrupted or doesn't exist. \nPlease contact Support.")
        }
    }
    
    func testPerformRequest_FailureResponse() async throws {
        // Arrange
        mockSession.data = nil
        mockSession.response = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                               statusCode: 500,
                                               httpVersion: nil,
                                               headerFields: nil)
        let endpoint = RecipeEndpoint()
        
        do {
            let _: RecipesResponse = try await requestService.performRequest(endpoint: endpoint, responseModel: RecipesResponse.self)
            XCTFail("Expected to throw an error but succeeded.")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Internal Server Error")
        }
    }
}
