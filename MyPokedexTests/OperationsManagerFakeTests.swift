//
//  MyPokedexTests.swift
//  MyPokedexTests
//
//  Created by Pedro  Rey Simons on 08/03/2021.
//

import XCTest
@testable import MyPokedex
import CoreData


class MyPokedexTests: XCTestCase {
    var sut:OperationsManager!//System Under Test
    
    override func setUpWithError() throws {
        super.setUp()
        sut = OperationsManager()

    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    //MARK:- OperationsManagerTest -
    
    func testGetBaseResourceOp() {
        // given
        let dataMock = MockData.baseThreeResources
        let urlMock = URL(string:"https://foo.foo")
        let responseMock = HTTPURLResponse(url: urlMock!, statusCode: 100, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: dataMock, response: responseMock, error: nil)
        sut.remoteDataManager = RemoteDataManager(session: sessionMock)

        let promise = expectation(description: "Base resource received")
        var resource:BaseResource?
        
        // when
        sut.getBaseResource { (result) in
            switch result{
                case .success(let baseResource):
                    resource = baseResource
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(resource!.resources!.count, 3 , "Didn't parse 3 items from fake response")
        XCTAssertEqual(resource!.resources![0].name, "bulbasaur")
        XCTAssertEqual(resource!.resources![1].name, "ivysaur")
        XCTAssertEqual(resource!.resources![2].name, "venusaur")
    }
    
    func testGetJsonDataOp() {
        // given
        let promise = expectation(description: "")
        //Lanza la petición y llama al completion handler
        let dataMock = MockData.jsonDataBulbasaur
        let urlMock = URL(string:"https://pokeapi.co/api/v2/pokemon/1/")
        let responseMock = HTTPURLResponse(url: urlMock!, statusCode: 100, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: dataMock, response: responseMock, error: nil)
        
        //sut.remoteDataManager.session = URLSession.shared
        sut.remoteDataManager.session = sessionMock

        var resourceEmpty = MockData.resourceBulbasaurEmptyData
        XCTAssertEqual(resourceEmpty.name,"bulbasaur")
        XCTAssertNil(resourceEmpty.data?.jsonData)

        sut.getJsonData(resources: [resourceEmpty]) { (result:Result<[NamedResource], Error>) in
            switch result{
                case .success(let results):
                    resourceEmpty = results.first!
                case .failure(_):
                    break
            }

            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(resourceEmpty.name,"bulbasaur")
        XCTAssertNotNil(resourceEmpty.data?.jsonData)
    }
}
