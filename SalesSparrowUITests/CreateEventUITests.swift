//
//  CreateEventUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 21/09/23.
//

import XCTest

final class CreateEventUITests: XCTestCase {
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

    func createEvent(app: XCUIApplication){
        //Check if cancel button exists
        let cancelButton = app.staticTexts["btn_add_event_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(cancelButton.isEnabled)

        let startDatePicker = app.datePickers["dp_add_event_select_start_date"]
        startDatePicker.tap()
        XCTAssertTrue(startDatePicker.exists, "Start Date picker should be open.")

        app.buttons["PopoverDismissRegion"].tap()
        
        let startTimePicker = app.datePickers["dp_add_event_select_start_time"]
        startTimePicker.tap()
        XCTAssertTrue(startTimePicker.exists, "Start Time picker should be open.")

        app.buttons["PopoverDismissRegion"].tap()
        
        let endDatePicker = app.datePickers["dp_add_event_select_end_date"]
        endDatePicker.tap()
        XCTAssertTrue(endDatePicker.exists, "End Date picker should be open.")

        app.buttons["PopoverDismissRegion"].tap()
        
        let endTimePicker = app.datePickers["dp_add_event_select_end_time"]
        endTimePicker.tap()
        XCTAssertTrue(endTimePicker.exists, "End Time picker should be open.")

        app.buttons["PopoverDismissRegion"].tap()
        
        let addEventTextField = app.textViews["et_create_event"]
        XCTAssertTrue(addEventTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addEventTextField.tap()
        //Type Text into the the text field
        addEventTextField.typeText("Create new event.\nTap on the save button to save it to salesforce.")
        
        let saveButton = app.buttons["btn_save_event"]
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

        let saveButton = app.buttons["btn_save_note"]
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
    
    func testCreateEventFromAccountEventlist() {
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        try? openAccountDetailUsingSearch(app: app)
        
        app.swipeUp()
        // Check the Add Event button
        let addEventButton = app.buttons["btn_account_detail_add_event"]
        XCTAssertTrue(addEventButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventButton.isEnabled) // Ensure the button is enabled
        addEventButton.tap()
        createEvent(app: app)
    }
    
    func testCreateEventFromSuggestEventlistPopOver() {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()

        let timeout = 5
        createNoteFromFloatingActionButton(app: app)

        // Open Popover and navigate to create event screen
        app.buttons["btn_create_note_popover_add_recommendation"].tap()
        XCTAssertTrue(app.staticTexts["txt_create_note_popover_add_event"].waitForExistence(timeout: TimeInterval(timeout)))
        app.buttons["btn_create_note_popover_add_event"].tap()
        

        createEvent(app: app)
    }
    
    
    func testDeleteRecommendedandSavedEvent(){
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        createNoteFromFloatingActionButton(app: app)
        
        let suggestionTitle = app.staticTexts["txt_create_note_recommendations"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))

        let eventIndex = 0
        app.swipeUp()
        let suggestedEvent = app.staticTexts["txt_create_note_event_suggestion_title_\(eventIndex)"]
        XCTAssertTrue(suggestedEvent.waitForExistence(timeout: TimeInterval(timeout)))
        let suggestedEventDescription = suggestedEvent.label

        let addEventBtn = app.buttons["btn_create_note_add_event_\(eventIndex)"]
        XCTAssertTrue(addEventBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventBtn.isEnabled)
        
        let cancelBtn = app.buttons["btn_create_note_event_cancel_\(eventIndex)"]
        XCTAssertTrue(cancelBtn.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelBtn.isEnabled)

        addEventBtn.tap()

        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        
        XCTAssertTrue(!app.buttons["btn_create_note_add_event_\(eventIndex)"].exists,"Suggest event add event button must be not visible")
        
        app.buttons["btn_create_note_event_more_\(eventIndex)"].tap()
        app.buttons["btn_create_note_delete_event_\(eventIndex)"].tap()
        
        app.buttons["btn_alert_submit"].tap()
        
        
        let suggestedEventAfterDelete = app.staticTexts["txt_create_note_event_suggestion_title_\(eventIndex)"]
        XCTAssertTrue(suggestedEventAfterDelete.waitForExistence(timeout: TimeInterval(timeout)))
        let suggestedEventDescriptionAfterDelete = suggestedEventAfterDelete.label
        
        //Verify that the event description before and after delete is not same
        XCTAssertTrue(suggestedEventDescription != suggestedEventDescriptionAfterDelete)
    }
    
    func testCreateEventFromSuggestedCard(){
        let timeout = 5
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        createNoteFromFloatingActionButton(app: app)
        
        let tileIndex = 0
        
        app.swipeUp()
        
        let suggestionTitle = app.staticTexts["txt_create_note_event_suggestion_title_\(tileIndex)"]
        XCTAssertTrue(suggestionTitle.waitForExistence(timeout: TimeInterval(timeout)))
        suggestionTitle.tap()
        
        createEvent(app: app)
    }
   
}

