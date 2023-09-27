//
//  EventsListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 21/09/23.
//

import XCTest

final class AccountDetailEventListUITests: XCTestCase {
    
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
    
    func testEventsSectionWithEmptyList() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","emptyEventList"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
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
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        // Check the Add Event button
        let addEventButton = app.buttons["btn_account_detail_add_event"]
        XCTAssertTrue(addEventButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addEventButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_creator_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_description_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_start_date_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_event_end_date_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.buttons["btn_account_detail_event_more_0"].isEnabled)
        
        let backButton = app.buttons["btn_account_detail_back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testEventsSectionWithError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","eventListError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        let accountNavigationLink = app.buttons["account_card_\(0)"]
        XCTAssertTrue(accountNavigationLink.waitForExistence(timeout: TimeInterval(timeout)))
        accountNavigationLink.tap()
        
        app.swipeUp()
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testAddEventButton() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
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
        let accountIndex = 0
        
        let accountNavigationLink = app.buttons["account_card_\(accountIndex)"]
        XCTAssertTrue(accountNavigationLink.waitForExistence(timeout: TimeInterval(timeout)))
        accountNavigationLink.tap()
        
        app.swipeUp()
        
        let EventCard = app.buttons["event_card_0"]
        XCTAssertTrue(EventCard.waitForExistence(timeout: TimeInterval(timeout)))
        EventCard.tap()
        
        let cancelButton = app.buttons["btn_event_detail_cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(cancelButton.isEnabled)
        
        XCTAssertTrue(app.staticTexts["txt_event_detail_start_date"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_start_time"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_end_date"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_event_detail_end_time"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_create_event_description"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_create_task_description"].waitForExistence(timeout: TimeInterval(timeout)))
        
        cancelButton.tap()
    }
    
    func testDeleteEvent() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        app.swipeUp()
        
        let threeDotButtonForEvent2 = app.buttons["btn_account_detail_event_more_1"]
        XCTAssertTrue(threeDotButtonForEvent2.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForEvent2.tap()
        
        let deleteButtonForEvent2 = app.buttons["btn_account_detail_delete_event_1"]
        XCTAssertTrue(deleteButtonForEvent2.waitForExistence(timeout: TimeInterval(timeout)))
        
        
        let threeDotButtonForEvent1 = app.buttons["btn_account_detail_event_more_0"]
        XCTAssertTrue(threeDotButtonForEvent1.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForEvent1.tap()
        
        let deleteButtonForEvent1 = app.buttons["btn_account_detail_delete_event_0"]
        XCTAssertTrue(deleteButtonForEvent1.waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForEvent1 = app.staticTexts["txt_account_detail_event_description_0"].label
        
        //Check whether the delete button is closed for event 2 on open of delete button for event 1
        XCTAssertFalse(deleteButtonForEvent2.exists)
        
        deleteButtonForEvent1.tap()
        
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
        
        XCTAssertFalse(app.staticTexts["txt_alert_message"].exists)
        
        let descriptionForEvent1AfterDelete = app.staticTexts["txt_account_detail_event_description_0"].label
        
        //Verify the event description for 1st event before and after delete are not same
        XCTAssertTrue(descriptionForEvent1 != descriptionForEvent1AfterDelete)
        
    }
    
    
    func testEditEvent() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        let accountNavigationLink = app.buttons["account_card_\(accountIndex)"]
        XCTAssertTrue(accountNavigationLink.waitForExistence(timeout: TimeInterval(timeout)))
        accountNavigationLink.tap()
        
        app.swipeUp()
        
        app.buttons["btn_account_detail_event_more_0"].tap()
        
        let addEventTextField = app.textViews["et_edit_event"]
        XCTAssertTrue(addEventTextField.waitForExistence(timeout: TimeInterval(timeout)))
        addEventTextField.tap()
        //Type Text into the the text field
        addEventTextField.typeText("Create new task.\nTap on the save button to save it to salesforce.")
        
        app.buttons["btn_save_task"].tap()
    }
    
    func testDeleteEventError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteEventError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
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
        
        
        //Check whether on error the toast is received
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForEvent1AfterDelete = app.staticTexts["txt_account_detail_event_description_0"].label
        
        //Verify the event description for 1st event before and after delete are same
        XCTAssertTrue(descriptionForEvent1 == descriptionForEvent1AfterDelete)
    }
}
