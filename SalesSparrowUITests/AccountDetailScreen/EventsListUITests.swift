//
//  EventsListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 21/09/23.
//

import XCTest

final class AccountDetailEventListUITests: XCTestCase {
    func navigationToEventSection(app: XCUIApplication) {
        let timeout = 5
        let accountIndex = 0
        
        let accountNavigationLink = app.buttons["account_card_\(accountIndex)"]
        XCTAssertTrue(accountNavigationLink.waitForExistence(timeout: TimeInterval(timeout)))
        accountNavigationLink.tap()
        
        app.swipeUp()
    }
    
    func testEventsSectionWithEmptyList() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "emptyEventList"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToEventSection(app: app)
        
        // Check the Add Event button
        let addEventButton = app.buttons["btn_account_detail_add_event"]
        XCTAssertTrue(addEventButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_add_event"].waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
    func testEventsSection() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToEventSection(app: app)
        
        // Check the Add Event button
        let addEventButton = app.buttons["btn_account_detail_add_event"]
        XCTAssertTrue(addEventButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_creator_\(accountIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_description_\(accountIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_start_date_\(accountIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_end_date_\(accountIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.buttons["btn_account_detail_event_more_\(accountIndex)"].isEnabled)
        
        let backButton = app.buttons["btn_account_detail_back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testEventsSectionWithError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "eventListError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToEventSection(app: app)
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testAddEventButton() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToEventSection(app: app)
        
        // Check the Add Event button
        let addEventButton = app.buttons["btn_account_detail_add_event"]
        XCTAssertTrue(addEventButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventButton.isEnabled) // Ensure the button is enabled
        
    }
    
    func testViewEvent() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToEventSection(app: app)
        
        let EventCard = app.buttons["event_card_0"]
        XCTAssertTrue(EventCard.waitForExistence(timeout: TimeInterval(timeout)))
        EventCard.tap()
        
        let doneButton = app.buttons["btn_event_detail_done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_event_detail_start_date"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_start_time"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_end_date"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_end_time"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_create_event_description"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_create_event_description"].waitForExistence(timeout: TimeInterval(timeout)))
        
        doneButton.tap()
    }
    
    func testViewEventWithError() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "viewTaskError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        navigationToEventSection(app: app)
        
        let EventCard = app.buttons["event_card_\(accountIndex)"]
        
        XCTAssertTrue(EventCard.waitForExistence(timeout: TimeInterval(timeout)))
        EventCard.tap()
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_details_title"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testDeleteEvent() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToEventSection(app: app)
        
        let descriptionForEvent1BeforeDelete = app.staticTexts["txt_account_detail_event_description_\(accountIndex)"].label
        
        let threeDotButtonForEvent2 = app.buttons["btn_account_detail_event_more_\(accountIndex)"]
        XCTAssertTrue(threeDotButtonForEvent2.waitForExistence(timeout: TimeInterval(timeout)))
        threeDotButtonForEvent2.tap()
        
        let deleteButtonForEvent2 = app.buttons["btn_account_detail_delete_event_\(accountIndex)"]
        XCTAssertTrue(deleteButtonForEvent2.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButtonForEvent2.tap()
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(deleteButton.isHittable)
        deleteButton.tap()
        
        // Verify the event description for 1st event before and after delete are not same
        XCTAssertTrue(descriptionForEvent1BeforeDelete != app.staticTexts["txt_account_detail_event_description_\(accountIndex)"].label)
    }
    
    func testEditEvent() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToEventSection(app: app)
        
        app.buttons["btn_account_detail_event_more_0"].tap()
        
        app.buttons["btn_account_detail_edit_event_0"].tap()
        
        let addEventTextField = app.textViews["et_edit_event"]
        XCTAssertTrue(addEventTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addEventTextField.tap()
        // Type Text into the the text field
        addEventTextField.typeText("\nUpdate this eveny.\nTap on the save button to save it to salesforce.")
        
        app.buttons["btn_save_event"].tap()
    }    
    
    func testEditEventWithError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteTaskError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToEventSection(app: app)
        
        app.buttons["btn_account_detail_event_more_0"].tap()
        
        app.buttons["btn_account_detail_edit_event_0"].tap()
        
        let addEventTextField = app.textViews["et_edit_event"]
        XCTAssertTrue(addEventTextField.waitForExistence(timeout: TimeInterval(timeout)))
        // Type Text into the the text field
        addEventTextField.typeText("\nUpdate this eveny.\nTap on the save button to save it to salesforce.")
        
        app.buttons["btn_save_event"].tap()
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testDeleteEventError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteEventError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToEventSection(app: app)
        
        let descriptionForEvent1 = app.staticTexts["txt_account_detail_event_description_0"].label
        
        app.swipeUp()
        let threeDotButtonForEvent1 = app.buttons["btn_account_detail_event_more_0"]
        XCTAssertTrue(threeDotButtonForEvent1.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForEvent1.tap()
        
        let deleteButtonForEvent1 = app.buttons["btn_account_detail_delete_event_0"]
        XCTAssertTrue(deleteButtonForEvent1.waitForExistence(timeout: TimeInterval(timeout)))
        
        deleteButtonForEvent1.tap()
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButton.tap()
        
        // Check whether on error the toast is received
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForEvent1AfterDelete = app.staticTexts["txt_account_detail_event_description_0"].label
        
        // Verify the event description for 1st event before and after delete are same
        XCTAssertEqual(descriptionForEvent1, descriptionForEvent1AfterDelete)
    }
}
