//
//  CreateTaskUITests.swift
//  SalesSparrowUITests
//
//  Created by Kartik Kapgate on 29/08/23.
//

import XCTest

final class CreateTaskUITests: XCTestCase {
    
    func openAccountDetailUsingSearch(app: XCUIApplication,accountName: String = "Test Account 1") throws {
        let timeout = 2
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        
        // modal should open with default data
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        btnSearchAccountNameBtn.tap()
    }
    
    func testSearchUser(app: XCUIApplication) throws {
        let timeout = 5
        let noteIndex = 0
        
        let searchUserButton = app.buttons["btn_create_task_search_user"]
        XCTAssertTrue(searchUserButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(searchUserButton.isEnabled)
        searchUserButton.tap()
        
        let userName = "Test User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()
        
        XCTAssertEqual(app.staticTexts["txt_create_note_suggestion_user_index_\(noteIndex)"].label,userName)
    }

    func createTaskFromAccountTasklist() throws {
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        try? openAccountDetailUsingSearch(app: app)
        
        // Check the Add Task button
        let addTaskButton = app.buttons["btn_account_detail_add_task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskButton.isEnabled) // Ensure the button is enabled
        addTaskButton.tap()

        //Check if cancel button exists
        let cancelButton = app.staticTexts["btn_add_task_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(cancelButton.isEnabled)

        let saveButton = app.buttons["btn_save_note"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: TimeInterval(timeout)))
        // save should not be clickable
        XCTAssertTrue(!saveButton.isEnabled)

        try? testSearchUser(app: app)
        
        let datePicker = app.datePickers["dp_add_task_select_date"]
        datePicker.tap()
        datePicker.collectionViews.buttons["Friday, January 14"].tap()
        datePicker.tap()
        
        let addTaskTextField = app.textViews["et_create_task"]
        XCTAssertTrue(addTaskTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addTaskTextField.tap()
        //Type Text into the the text field
        addTaskTextField.typeText("Create new task and assign it to a user.\nTap on the save button to save it to salesforce.")

        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
    }
}

