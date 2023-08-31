//
//  CreateTaskUITests.swift
//  SalesSparrowUITests
//
//  Created by Kartik Kapgate on 29/08/23.
//

import XCTest

final class CreateTaskUITests: XCTestCase {
    let timeout = 5
    
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
    
    func SearchUser(app: XCUIApplication) {
        let timeout = 5
        
        let searchUserButton = app.buttons["btn_create_task_search_user"]
        XCTAssertTrue(searchUserButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(searchUserButton.isEnabled)
        searchUserButton.tap()
        
        let userName = "Test User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()
    }

    func createTask(app: XCUIApplication){
        //Check if cancel button exists
        let cancelButton = app.staticTexts["btn_add_task_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(cancelButton.isEnabled)

        try? SearchUser(app: app)

        let datePicker = app.datePickers["dp_add_task_select_date"]
        datePicker.tap()
        XCTAssertTrue(datePicker.exists, "Date picker should be open.")

        app.buttons["PopoverDismissRegion"].tap()
        
        let addTaskTextField = app.textViews["et_create_task"]
        XCTAssertTrue(addTaskTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addTaskTextField.tap()
        //Type Text into the the text field
        addTaskTextField.typeText("Create new task and assign it to a user.\nTap on the save button to save it to salesforce.")
        
        let saveButton = app.buttons["btn_save_task"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: TimeInterval(timeout)))
        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
    }
    
    func createNoteFromFloatingActionButton(app: XCUIApplication){
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

        let saveButton = app.buttons["btn_create_note_save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: TimeInterval(timeout)))
        // save should not be clickable
        XCTAssertTrue(!saveButton.isEnabled)

        let selectAccount = app.staticTexts["txt_create_note_select_account"]
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
    }
    
    func testCreateTaskFromAccountTasklist() {
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

        createTask(app: app)
    }
    
    func testCreateTaskFromSuggestTasklistPopOver() {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        let timeout = 5
        createNoteFromFloatingActionButton(app: app)

        // Open Popover and navigate to create task screen
        app.buttons["btn_create_note_popover_create_task"].tap()
        XCTAssertTrue(app.staticTexts["txt_create_note_popover_add_task"].waitForExistence(timeout: TimeInterval(timeout)))
        app.buttons["btn_create_note_popover_add_task"].tap()
        

        createTask(app: app)
    }
    
    func testDeleteRecommendedandSavedTask(){
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        createNoteFromFloatingActionButton(app: app)
        
        let suggestionTitle = app.staticTexts["txt_create_note_recommendations"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))

        let taskIndex = 0
        let suggestedNote = app.staticTexts["txt_create_note_suggestion_title_index_\(taskIndex)"]
        XCTAssertTrue(suggestedNote.waitForExistence(timeout: TimeInterval(timeout)))

        let assignToButton = app.buttons["btn_create_note_search_user_index_\(taskIndex)"]
        XCTAssertTrue(assignToButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(assignToButton.isEnabled)
        assignToButton.tap()
        
        let userName = "Test User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()

        let addTaskBtn = app.buttons["btn_create_note_add_task_\(taskIndex)"]
        XCTAssertTrue(addTaskBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskBtn.isEnabled)
        
        let cancelBtn = app.buttons["btn_create_note_cancel_\(taskIndex)"]
        XCTAssertTrue(cancelBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelBtn.isEnabled)

        addTaskBtn.tap()

        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        app.buttons["btn_create_note_task_more_\(taskIndex)"].tap()
        app.buttons["btn_create_note_delete_task_\(taskIndex)"].tap()
        
        app.buttons["btn_alert_submit"].tap()
        
        XCTAssertTrue(!app.staticTexts["txt_create_note_suggestion_title_index_\(taskIndex)"].exists,"Suggest task text must disappear")
        XCTAssertTrue(!app.buttons["btn_create_note_add_task_\(taskIndex)"].exists,"Suggest task add task button must be not visible")
    }
    
    func testCreateTaskFromSuggestedCard(){
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        createNoteFromFloatingActionButton(app: app)
        
        let tileIndex = 0
        
        let suggestionTitle = app.staticTexts["txt_create_note_suggestion_title_index_\(tileIndex)"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))
        suggestionTitle.tap()
        
        createTask(app: app)
    }
}

