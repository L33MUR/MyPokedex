//
//  MyPokedexUITests.swift
//  MyPokedexUITests
//
//  Created by Pedro  Rey Simons on 27/02/2021.
//

import XCTest

class PokedexUITests: XCTestCase {
    var app:XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReset_ShowDetail_Delete(){
        //reset data base at launch
        app.navigationBars["Pokedex"].buttons["Refresh"].tap()
        XCTAssert(app.alerts["Reset Data Base"].exists)
        app.alerts["Reset Data Base"].scrollViews.otherElements.buttons["Reset"].tap()
        
        //Waits for database reset
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"#1").element.waitForExistence(timeout: 5)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"#1").element.tap()
        
        //Waits for show detail
        app.navigationBars["Bulbasaur"].waitForExistence(timeout: 2)
        app.navigationBars["Bulbasaur"].buttons["Delete"].tap()
        app.alerts["Delete Bulbasaur"].scrollViews.otherElements.buttons["Delete"].tap()

        sleep(1)
        //Waits for back from detail, #1 cell not exists anymore after delete
        XCTAssertFalse(app.collectionViews.cells.otherElements.containing(.staticText, identifier:"#1").element.exists)
    }
}
