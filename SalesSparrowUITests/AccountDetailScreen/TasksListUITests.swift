//
//  TasksListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//

import XCTest

final class AccountDetailTaskListUITests: XCTestCase {
    
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
    
    func testTasksSectionWithEmptyList() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","emptyTaskList"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        // Check the Add Task button
        let addTaskButton = app.buttons["btn_account_detail_add_task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_add_task"].waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
    func testTasksSection() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        // Check the Add Task button
        let addTaskButton = app.buttons["btn_account_detail_add_task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskButton.isEnabled) // Ensure the button is enabled
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_task_creator_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_task_description_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_task_assignee_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_task_due_date_0"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let backButton = app.buttons["btn_account_detail_back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testTasksSectionWithError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","taskListError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testAddTaskButton() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        // Check the Add Task button
        let addTaskButton = app.buttons["btn_account_detail_add_task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskButton.isEnabled) // Ensure the button is enabled
        
    }
    
    func testDeleteTask() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        let threeDotButtonForTask2 = app.buttons["btn_account_detail_task_more_1"]
        XCTAssertTrue(threeDotButtonForTask2.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForTask2.tap()
        
        let deleteButtonForTask2 = app.buttons["btn_account_detail_delete_task_1"]
        XCTAssertTrue(deleteButtonForTask2.waitForExistence(timeout: TimeInterval(timeout)))
        
        
        let threeDotButtonForTask1 = app.buttons["btn_account_detail_task_more_0"]
        XCTAssertTrue(threeDotButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForTask1.tap()
        
        let deleteButtonForTask1 = app.buttons["btn_account_detail_delete_task_0"]
        XCTAssertTrue(deleteButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForTask1 = app.staticTexts["txt_account_detail_task_description_0"].label
        
        //Check whether the delete button is closed for task 2 on open of delete button for task 1
        XCTAssertFalse(deleteButtonForTask2.exists)
        
        deleteButtonForTask1.tap()
        
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
        
        let descriptionForTask1AfterDelete = app.staticTexts["txt_account_detail_task_description_0"].label
        
        //Verify the task description for 1st task before and after delete are not same
        XCTAssertTrue(descriptionForTask1 != descriptionForTask1AfterDelete)
        
        
    }
    
    func testDeleteTaskError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteTaskError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
     
        let threeDotButtonForTask1 = app.buttons["btn_account_detail_task_more_0"]
        XCTAssertTrue(threeDotButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        
        threeDotButtonForTask1.tap()
        
        let descriptionForTask1 = app.staticTexts["txt_account_detail_task_description_0"].label
        
        let deleteButtonForTask1 = app.buttons["btn_account_detail_delete_task_0"]
        XCTAssertTrue(deleteButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        
        deleteButtonForTask1.tap()
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButton.tap()
        
        
        //Check whether on error the toast is received
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForTask1AfterDelete = app.staticTexts["txt_account_detail_task_description_0"].label
        
        //Verify the task description for 1st task before and after delete are same
        XCTAssertTrue(descriptionForTask1 == descriptionForTask1AfterDelete)
    }
}
