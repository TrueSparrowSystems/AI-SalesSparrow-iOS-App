//
//  SalesSparrowUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 31/07/23.
//

import XCTest

final class SalesSparrowUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLoginScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        let timeout = 2
        let salesforceConnectButton = app.buttons["btn_connect_salesforce"]
        XCTAssertTrue(salesforceConnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        salesforceConnectButton.tap()
        app.activate()
        
    }
    
    func testSearchAccountOnHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "userLoggedIn"]
        app.launch()
        
        let timeout = 2
        // click on search icon home page
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        // modal should open with empty text box
        let textFieldSearchAccount = app.textFields["text_field_search_account"]
        XCTAssertTrue(textFieldSearchAccount.waitForExistence(timeout: TimeInterval(timeout)))
        let textFieldSearchAccountVal = textFieldSearchAccount.value as? String
        XCTAssertTrue(((textFieldSearchAccountVal?.isEmpty) != nil))
        
        // modal should open with default data
        let accountName = "Test Data 1"
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchAccountNameBtn.isEnabled)
        
        // there should be add note button in it
        let btnSearchAddNoteBtn = app.buttons["btn_search_add_note_\(accountName)"]
        XCTAssertTrue(btnSearchAddNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(btnSearchAddNoteBtn.isEnabled)
                
        app.activate()
        
    }
    
    func testSearchAccountWithQueryOnHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "userLoggedIn", "searchResponseWithQuery"]
        app.launch()
        
        let timeout = 2
        // click on search icon home page
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        // modal should open with empty text box
        let textFieldSearchAccount = app.textFields["text_field_search_account"]
        XCTAssertTrue(textFieldSearchAccount.waitForExistence(timeout: TimeInterval(timeout)))
        textFieldSearchAccount.tap()
        textFieldSearchAccount.typeText("Mock Account")
        XCTAssertEqual(textFieldSearchAccount.value as! String, "Mock Account")
        
        // modal should open with default data
        let accountName = "Mock Account 1"
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchAccountNameBtn.isEnabled)
        
        // there should be add note button in it
        let btnSearchAddNoteBtn = app.buttons["btn_search_add_note_\(accountName)"]
        XCTAssertTrue(btnSearchAddNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(btnSearchAddNoteBtn.isEnabled)
                
        
        app.activate()
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
