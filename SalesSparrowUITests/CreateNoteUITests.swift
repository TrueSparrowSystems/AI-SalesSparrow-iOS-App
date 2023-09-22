//
//  CreateNoteUITests.swift
//  SalesSparrowUITests
//
//  Created by Alpesh Modi on 24/08/23.
//

import XCTest

final class CreateNoteUITests: XCTestCase {
    func openAccountDetailUsingSearch(app: XCUIApplication,accountName: String = "Test Account 1") {
        let timeout = 2
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        
        // modal should open with default data
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        btnSearchAccountNameBtn.tap()
    }
    
    func createNoteFromAccountNotelist(app: XCUIApplication,accountName: String = "Test Account 1") {
        let timeout = 5
        
        // Check the Add Note button
        let addNoteButton = app.buttons["btn_account_detail_add_note"]
        XCTAssertTrue(addNoteButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addNoteButton.isEnabled) // Ensure the button is enabled
        addNoteButton.tap()

        //Check if cancel button exists
        let cancelButton = app.staticTexts["btn_cancel_create_note"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(cancelButton.isEnabled)

        let saveButton = app.buttons["btn_save_note"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: TimeInterval(timeout)))
        // save should not be clickable
        XCTAssertTrue(!saveButton.isEnabled)

        let accountName = "Test Account 1"
        let selectedAccount = app.staticTexts["txt_create_note_selected_account"]
        XCTAssertTrue(selectedAccount.waitForExistence(timeout: TimeInterval(timeout)))
        // Get the text from the selectedAccount element
        let selectedAccountText = selectedAccount.label
        // Check if the selectedAccountText matches the accountName
        XCTAssertEqual(selectedAccountText, accountName)
        //Check for Create Note text field
        let addNoteTextField = app.textViews["et_create_note"]
        XCTAssertTrue(addNoteTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addNoteTextField.tap()
        //Type Text into the the text field
        addNoteTextField.typeText("""
                                Presentation on how we would prepare and plan a migration from PHP to Ruby.
                                  Get number of teams members and detailed estimates for Smagic.  Rachin to lead this. Meeting with Smagic scheduled for this saturday 5 pm.
                                """)

        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()

    }
    
    func testCreateNote() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)

        createNoteFromAccountNotelist(app: app)
    }
    
    func testGenerateRecommendationAndAddTask() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        // Set the timeout duration
        let timeout = 5

        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)

        createNoteFromAccountNotelist(app: app)

        let suggestionTitle = app.staticTexts["txt_create_note_recommendations"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))

        let noteIndex = 0
        let suggestedNote = app.staticTexts["txt_create_note_suggestion_title_index_\(noteIndex)"]
        XCTAssertTrue(suggestedNote.waitForExistence(timeout: TimeInterval(timeout)))

        let assignToButton = app.buttons["btn_create_note_search_user_index_\(noteIndex)"]
        XCTAssertTrue(assignToButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(assignToButton.isEnabled)
        assignToButton.tap()
        
        let userName = "Test User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()

        let addTaskBtn = app.buttons["btn_create_note_add_task_\(noteIndex)"]
        XCTAssertTrue(addTaskBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskBtn.isEnabled)
        
        let cancelBtn = app.buttons["btn_create_note_cancel_\(noteIndex)"]
        XCTAssertTrue(cancelBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelBtn.isEnabled)

        addTaskBtn.tap()

        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testGenerateRecommendationAndCancelTask() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        // Set the timeout duration
        let timeout = 5

        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)

        createNoteFromAccountNotelist(app: app)

        let suggestionTitle = app.staticTexts["txt_create_note_recommendations"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))

        let noteIndex = 0
        let suggestedTask = app.staticTexts["txt_create_note_suggestion_title_index_\(noteIndex)"]
        XCTAssertTrue(suggestedTask.waitForExistence(timeout: TimeInterval(timeout)))
        let suggestedTaskDescription = suggestedTask.label
        
        let assignToButton = app.buttons["btn_create_note_search_user_index_\(noteIndex)"]
        XCTAssertTrue(assignToButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(assignToButton.isEnabled)
        assignToButton.tap()
        
        let userName = "Test User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()

        let addTaskBtn = app.buttons["btn_create_note_add_task_\(noteIndex)"]
        XCTAssertTrue(addTaskBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskBtn.isEnabled)
        
        let cancelBtn = app.buttons["btn_create_note_cancel_\(noteIndex)"]
        XCTAssertTrue(cancelBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelBtn.isEnabled)

        cancelBtn.tap()
        
        app.buttons["btn_alert_submit"].tap()
        
        let suggestedTaskAfterDelete = app.staticTexts["txt_create_note_suggestion_title_index_\(noteIndex)"]
        XCTAssertTrue(suggestedTaskAfterDelete.waitForExistence(timeout: TimeInterval(timeout)))
        let suggestedTaskDescriptionAfterDelete = suggestedTaskAfterDelete.label

        //Verify that the task description before and after cancel is not same
        XCTAssertTrue(suggestedTaskDescription != suggestedTaskDescriptionAfterDelete)
    }

    func testSearchUser() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        let timeout = 2
        
        openAccountDetailUsingSearch(app: app)
        
        createNoteFromAccountNotelist(app: app)
        
        let noteIndex = 0
        let searchUserButton = app.buttons["btn_create_note_search_user_index_\(noteIndex)"]
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

    func testSearchUserWithQuery() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "searchUserWithQuery"]
        app.launch()

        let timeout = 2
        openAccountDetailUsingSearch(app: app)
        
        createNoteFromAccountNotelist(app: app)
        
        let noteIndex = 0
        let searchUserButton = app.buttons["btn_create_note_search_user_index_\(noteIndex)"]
        XCTAssertTrue(searchUserButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(searchUserButton.isEnabled)
        searchUserButton.tap()
        
        let userName = "Mock User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()
        
        XCTAssertEqual(app.staticTexts["txt_create_note_suggestion_user_index_\(noteIndex)"].label,userName)
    }

}
