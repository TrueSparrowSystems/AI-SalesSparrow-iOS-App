//
//  NoteListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//


import XCTest

final class AccountDetailNoteListUITests: XCTestCase {
    
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
    
    func testNotesSectionWithEmptyList() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","emptyNoteList"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        // Check the Add Note button
        let addNoteButton = app.buttons["btn_account_detail_add_note"]
        XCTAssertTrue(addNoteButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addNoteButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_add_note_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
    func testNotesSection() throws {
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
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_note_creator_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_note_text_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let backButton = app.buttons["btn_account_detail_back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: TimeInterval(timeout)))
        //        backButton.tap()
    }
    
    func testNotesSectionWithError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","noteListError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    
    func testViewNoteButton() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        let firstNoteCard = app.buttons["note_card_note_100"] // Replace "100" with the appropriate index
        // Check if the note card exists
        XCTAssertTrue(firstNoteCard.waitForExistence(timeout: TimeInterval(timeout)))
        // Tap the note card to view it
        firstNoteCard.tap()
        
        // check if you are on the note detail screen by checking appropriate elements
        
        // check the done button
        let doneButton = app.staticTexts["btn_note_screen_done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5))
        XCTAssertTrue(doneButton.isEnabled)
        
        // check the account icon
        XCTAssertTrue(app.images["img_note_detail_account_icon"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // check the "Account" title
        XCTAssertTrue(app.staticTexts["txt_note_detail_account_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // check the account name
        XCTAssertTrue(app.staticTexts["txt_note_detail_account_name"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check if the HTMLTextView content exists
        XCTAssertTrue(app.textViews["txt_note_detail_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testAddNoteButton() throws {
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
        addNoteTextField.typeText("Create A New Note")
        
        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        let doneButton = app.staticTexts["btn_done_create_note"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(doneButton.isEnabled)
        
    }

    func testEditNote() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        let noteIndex = 0
        let threeDotButtonForNote = app.buttons["btn_account_detail_edit_note_\(noteIndex)"]
        XCTAssertTrue(threeDotButtonForNote.waitForExistence(timeout: TimeInterval(timeout)))
        threeDotButtonForNote.tap()
        
        app.buttons["btn_account_detail_edit_\(noteIndex)"].tap()
        
        let addNoteTextField = app.textViews["et_edit_note"]
        XCTAssertTrue(addNoteTextField.waitForExistence(timeout: TimeInterval(timeout)))
        //Type Text into the the text field
        addNoteTextField.typeText("Create new note.\nTap on the save button to save it to salesforce.")
        
        app.buttons["btn_save_task"].tap()
        
        XCTAssertTrue(app.staticTexts["txt_alert_message"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testDeleteNote() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        let noteIndex = 0
        
        let initialNote = app.staticTexts["txt_account_detail_note_text_\(noteIndex)"].label
        
        let threeDotButtonForNote = app.buttons["btn_account_detail_edit_note_\(noteIndex)"]
        XCTAssertTrue(threeDotButtonForNote.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForNote.tap()
        
        app.buttons["btn_account_detail_delete_note_\(noteIndex)"].tap()
        
        // Check if delete confirmation modal is visible
        // Verify message, cancel and delete button
        XCTAssertTrue(app.staticTexts["txt_alert_message"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let cancelButton = app.buttons["btn_alert_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelButton.isHittable)
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(deleteButton.isHittable)
        deleteButton.tap()
        
        XCTAssertTrue(initialNote != app.staticTexts["txt_account_detail_note_text_\(noteIndex)"].label)
    }
    
    func testDeleteNoteError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteNoteError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
     
        let noteIndex = 0
        
        let initialNote = app.staticTexts["txt_account_detail_note_text_\(noteIndex)"].label
        
        let threeDotButtonForNote = app.buttons["btn_account_detail_edit_note_\(noteIndex)"]
        XCTAssertTrue(threeDotButtonForNote.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForNote.tap()
        
        app.buttons["btn_account_detail_delete_note_\(noteIndex)"].tap()
        
        // Check if delete confirmation modal is visible
        // Verify message, cancel and delete button
        XCTAssertTrue(app.staticTexts["txt_alert_message"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let cancelButton = app.buttons["btn_alert_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelButton.isHittable)
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(deleteButton.isHittable)
        deleteButton.tap()
        
        
        //Check whether on error the toast is received
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let textForNote1AfterDelete = app.staticTexts["txt_account_detail_note_text_\(noteIndex)"].label
        
        //Verify the note text for 1st note before and after delete are same
        XCTAssertTrue(initialNote == textForNote1AfterDelete)
    }
}
