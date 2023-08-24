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
    
    func testGenerateRecommendation() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        // Set the timeout duration
        let timeout = 5

        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)

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
        let selectedAccount = app.staticTexts["cn_selected_account"]
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


        let suggestionTitle = app.staticTexts["txt_create_note_recommendations"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))

        let suggestedNote = app.textViews["txt_create_note_suggestion"]
        XCTAssertTrue(suggestedNote.waitForExistence(timeout: TimeInterval(timeout)))

        let assignToButtonText = app.staticTexts["txt_create_note_assign_to"]
        XCTAssertTrue(assignToButtonText.waitForExistence(timeout: TimeInterval(timeout)))

        let dueButtonText = app.staticTexts["txt_create_note_due"]
        XCTAssertTrue(dueButtonText.waitForExistence(timeout: TimeInterval(timeout)))

        let assignToPicker = app.buttons["btn_create_note_assign_to"]
        XCTAssertTrue(assignToPicker.waitForExistence(timeout: TimeInterval(timeout)))

        assignToPicker.tap()

        // modal should open with empty text box
        let textFieldSearchAccount = app.textFields["txt_search_user_field"]
        XCTAssertTrue(textFieldSearchAccount.waitForExistence(timeout: TimeInterval(timeout)))
        let textFieldSearchAccountVal = textFieldSearchAccount.value as? String
        XCTAssertTrue(((textFieldSearchAccountVal?.isEmpty) != nil))

        // modal should open with default data
        let userName = "Test User 1"
        let SearchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(SearchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // user row should be clickable
        SearchUserNameBtn.tap()

        let addTaskBtn = app.buttons["btn_create_note_add_task"]
        XCTAssertTrue(addTaskBtn.waitForExistence(timeout: TimeInterval(timeout)))

        let cancelBtn = app.buttons["btn_create_note_cancel"]
        XCTAssertTrue(cancelBtn.waitForExistence(timeout: TimeInterval(timeout)))

        addTaskBtn.tap()

        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }

    func testSearchUser() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        let timeout = 2

        let searchAccountButton = app.buttons["btn_create_task_search_user"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()

        let textFieldSearchUser = app.textFields["txt_search_user_field"]
        XCTAssertTrue(textFieldSearchUser.waitForExistence(timeout: TimeInterval(timeout)))
        textFieldSearchUser.tap()
        textFieldSearchUser.typeText("Mock User")
        XCTAssertEqual(textFieldSearchUser.value as! String, "Mock User")

        // modal should open with default data
        let userName = "Mock User"
        let searchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(searchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        searchUserNameBtn.tap()
    }

    func testSearchUserWithQuery() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "searchResponseWithQuery"]
        app.launch()

        let timeout = 2
        // click on search icon home page
        let searchUserButton = app.buttons["btn_create_task_search_user"]
        XCTAssertTrue(searchUserButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchUserButton.tap()
        // modal should open with empty text box
        let textFieldSearchUser = app.textFields["txt_search_user_field"]
        XCTAssertTrue(textFieldSearchUser.waitForExistence(timeout: TimeInterval(timeout)))
        textFieldSearchUser.tap()
        textFieldSearchUser.typeText("Mock User")
        XCTAssertEqual(textFieldSearchUser.value as! String, "Mock User")

        // modal should open with default data
        let userName = "Mock User"
        let btnSearchUserNameBtn = app.buttons["btn_search_user_user_name_\(userName)"]
        XCTAssertTrue(btnSearchUserNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchUserNameBtn.isEnabled)
    }

}
