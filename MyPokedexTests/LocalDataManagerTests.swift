//
//  LocalDataManagerTests.swift
//  MyPokedexTests
//
//  Created by Pedro  Rey Simons on 08/03/2021.
//

import XCTest
@testable import MyPokedex
import CoreData

class LocalDataManagerTests: XCTestCase {
    var testCoreDataStack: TestCoreDataStack!
    var localDataManager: LocalDataManager!
    
    let creator = NamedResource.pokemonEntityInstantiator//Creates a PokemonEntity from a NamedResource
    let bulbasaur = MockData.resourceBulbasaurWithData
    
    // in-memory store initialized each time executes
    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        localDataManager = LocalDataManager(managedObjectContext: testCoreDataStack.mainContext, coreDataStack: testCoreDataStack)
    }
    
    //Preparation for the next test.
    override func tearDown() {
        super.tearDown()
        testCoreDataStack = nil
        localDataManager = nil
    }
    
    func testPokemonEntityInstantiator() {
        //given
        let newInstance = creator(bulbasaur, testCoreDataStack.mainContext)
        //then
        XCTAssertNotNil(newInstance, "newInstance should not be nil")
        XCTAssertNotNil(newInstance.image,"Image should not be nil")
        XCTAssertNotNil(newInstance.jsonData,"jsonData should note be nil")
        XCTAssertEqual(newInstance.id, 1)
        XCTAssertEqual(newInstance.isCaptured, false)
        XCTAssertEqual(newInstance.resourceName, "bulbasaur")
        XCTAssertEqual(newInstance.resourceUrl, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    //Creates a newInstance for testing a further request
    func testCreateInstance(){
        XCTAssertNotNil(createPokemonInstance(),"Should return an instance")
    }
    
    //Creates a newInstance for testing a further request
    func testReadInstance(){
        //given
        XCTAssertNotNil(createPokemonInstance(),"Should return an instances")
        //then
        let instancesToRead = readPokemonsInstances()
        
        //then
        XCTAssert(instancesToRead?.count == 1,"Should contain only the instance created")
        XCTAssert(instancesToRead?.first!.resourceName == bulbasaur.name)
        XCTAssert(instancesToRead?.first!.resourceUrl == bulbasaur.url)
        XCTAssert(instancesToRead?.first!.id == bulbasaur.data?.id)
    }
    
    //Creates a newInstance for testing a further update
    func testUpdateInstance(){
        //given
        createPokemonInstance()?.isCaptured = true //Default value is false
        //when
        updateChanges()
        //then
        XCTAssert(readPokemonsInstances()?.count == 1,"Should contain only the instance created and edited")
        XCTAssert(readPokemonsInstances()?.first?.isCaptured == true, "isCaptured should be equal to true after update")
    }
    
        
    //Creates a newInstance for testing a further deletion
    func testDeleteInstance(){
        //given
        XCTAssertNotNil(createPokemonInstance(),"Should return an instance")
        let instancesToDelete = readPokemonsInstances()
        XCTAssert(instancesToDelete?.count == 1,"Should contain only the instance created")
        //when
        deleteInstances(instances:instancesToDelete!)
        //then
        XCTAssertNotNil(readPokemonsInstances(),"Readed objects should return an empty array []")
        XCTAssert(readPokemonsInstances()?.count == 0,"Readed objects should return an empty array []")
    }
    
    func createPokemonInstance()->PokemonEntity?{
        //given
        let promise = expectation(description: "Create completion called")
        var bulbasaurInstance:PokemonEntity?
        
        //when
        localDataManager.createInstances(objects: [bulbasaur], creator: creator) { (result) in
            promise.fulfill()
            switch result{
                case .success(let newInstances):
                    bulbasaurInstance = (newInstances.first as! PokemonEntity)
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)

        //then
        ///print(String(data: (bulbasaurInstance?.jsonData)!, encoding: .utf8)!)
        XCTAssertNotNil(bulbasaurInstance?.jsonData)
        XCTAssert(bulbasaurInstance?.resourceName == bulbasaur.name)
        XCTAssert(bulbasaurInstance?.resourceUrl == bulbasaur.url)
        XCTAssert(bulbasaurInstance?.id == bulbasaur.data?.id)
        
        return bulbasaurInstance
    }
    
    func updateChanges(){
        let promise = expectation(description: "Save completion called")
        localDataManager.updateChanges { (result) in
            promise.fulfill()
            switch result{
                case .success(_):
                   break
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func readPokemonsInstances()->[PokemonEntity]?{
        //given
        let promise = expectation(description: "Read completion handler")
        let entityName:String = Constants.Entities.pokemonEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var readedObjects:[PokemonEntity]? //bulbasaurInstance
        
        //when
        localDataManager.readInstances(fetchRequest: fetchRequest) { (result) in
            promise.fulfill()
            switch result{
                case .success(let objects):
                    readedObjects = (objects as! [PokemonEntity])
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
        return readedObjects
    }
    
    func deleteInstances(instances:[NSManagedObject]){
        let promise = expectation(description: "Delete completion handler")
        localDataManager.deleteInstances(instances:instances) { (result) in
            promise.fulfill()
            switch result{
                case .success(_):
                    break
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
