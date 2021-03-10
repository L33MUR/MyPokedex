//
//  IntegrationTests.swift
//  MyPokedexTests
//
//  Created by Pedro  Rey Simons on 10/03/2021.
//

import XCTest
@testable import MyPokedex
import CoreData

class IntegrationTests: XCTestCase {
    var sut:OperationsManager!//System Under Test
    
    override func setUpWithError() throws {
        super.setUp()
        sut = OperationsManager()

    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    
    //Main Core Operation
    func testGetAndSaveData(){
        let promise = expectation(description: "Completion")
        //given
        sut.remoteDataManager.session = URLSession(configuration: .default)
        //when
        sut.getAndSaveData { (result) in
            switch result{
                case .success(_):
                    promise.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 5)
        //then
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.pokemonEntity)
        sut.localDataManager.readInstances(fetchRequest: fetchRequest) { (result) in
            switch result{
                case .success(let objects):
                    XCTAssertEqual(objects.count, 151)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }

}
