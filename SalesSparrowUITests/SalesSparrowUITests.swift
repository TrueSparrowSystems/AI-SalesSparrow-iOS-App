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
    
    func testLoginScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","loggedOutUser"]
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
        let accountName = "Test Account 1"
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchAccountNameBtn.isEnabled)
        
        // there should be add note button in it
        let btnSearchAddNoteBtn = app.buttons["btn_search_add_note_\(accountName)"]
        XCTAssertTrue(btnSearchAddNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(btnSearchAddNoteBtn.isEnabled)
        
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
    }
    
    func testCreateNoteScreen(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        let timeout = 2
        // there should be add note button in it
        let createNoteBtn = app.buttons["btn_create_note"]
        XCTAssertTrue(createNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(createNoteBtn.isEnabled)
        createNoteBtn.tap()
        
        //Check if cancel button exists
        let cancelButton = app.staticTexts["btn_cancel_create_note"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(cancelButton.isEnabled)
        
        let saveButton = app.buttons["btn_save_note"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: TimeInterval(timeout)))
        // save should not be clickable
        XCTAssertTrue(!saveButton.isEnabled)
        
        let selectAccount = app.staticTexts["btn_select_account"]
        XCTAssertTrue(selectAccount.waitForExistence(timeout: TimeInterval(timeout)))
        // select should be clickable
        XCTAssertTrue(selectAccount.isEnabled)
        selectAccount.tap()
        
        let accountName = "Test Account 1"
        let searchAccountBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(searchAccountBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(searchAccountBtn.isEnabled)
        searchAccountBtn.tap()
        
        //Check for Create Note text field
        let addNoteTextField = app.textViews["et_create_note"]
        XCTAssertTrue(addNoteTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addNoteTextField.tap()
        //Type Text into the the text field
        addNoteTextField.typeText("Create A New Note")
        
        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        let doneButton = app.staticTexts["btn_done_create_note"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(doneButton.isEnabled)
    }
}
