//
//  RemoteDataManagerTest.swift
//  MyPokedexTests
//
//  Created by Pedro  Rey Simons on 08/03/2021.
//

import XCTest
@testable import MyPokedex


class RemoteDataManagerTest: XCTestCase {
    var sut:RemoteDataManager!
    let baseURL = Constants.Endpoints.baseURL() //"https://pokeapi.co/api/v2/pokemon?limit=151&offset=0" //Resources to obtain pokemon data

    override func setUpWithError() throws {
        super.setUp()
        sut = RemoteDataManager(session: URLSession(configuration: URLSessionConfiguration.default))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testFetchDataResponse(){
        let promise = expectation(description: "Completion handler invoked -> Answer received from API")
        //given
        var statusCode: Int?
        var responseError: Error?

        //when
        sut.fetchData(endpoint:baseURL) { (result) in
            promise.fulfill()
            switch result{
                case .success(let (_,response)):
                    statusCode = response.statusCode
                case .failure(let error):
                    responseError = error
            }
            
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testFetchGenericJSONObject(){
        let promise = expectation(description: "Completion handler invoked -> Answer received from API")
        //given
        var resource:BaseResource?
        let expectedNext = "https://pokeapi.co/api/v2/pokemon?offset=151&limit=151" //URL for the next BaseResource chunk, is a property of the received BaseResource

        //when
        sut.fetchGenericJSONObject(endpoint: baseURL) { (result:Result<BaseResource, Error>) in
            promise.fulfill()
            switch result{
                case .success(let decodedResource):
                    resource = decodedResource
                case .failure(let error):
                    XCTFail("The service should not fail: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertEqual(resource?.next, expectedNext)
    }
}
