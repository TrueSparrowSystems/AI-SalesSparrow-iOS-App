//
//  TasksListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//

import XCTest

final class AccountDetailTaskListUITests: XCTestCase {
    func navigationToTaskSection(app: XCUIApplication) {
        let timeout = 5
        let accountIndex = 0
        
        let accountNavigationLink = app.buttons["account_card_\(accountIndex)"]
        XCTAssertTrue(accountNavigationLink.waitForExistence(timeout: TimeInterval(timeout)))
        accountNavigationLink.tap()
        
        app.swipeUp()
    }
    
    func testTasksSectionWithEmptyList() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "emptyTaskList"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToTaskSection(app: app)
        
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
        
        navigationToTaskSection(app: app)
        
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
        app.launchArguments = ["isRunningUITests", "taskListError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToTaskSection(app: app)
        
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_account_detail_add_task"].waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
    func testAddTaskButton() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToTaskSection(app: app)
        
        // Check the Add Task button
        let addTaskButton = app.buttons["btn_account_detail_add_task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(addTaskButton.isEnabled) // Ensure the button is enabled
        
    }
    
    func testViewTask() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        
        navigationToTaskSection(app: app)
        
        let taskCard = app.buttons["task_card_0"]
        XCTAssertTrue(taskCard.waitForExistence(timeout: TimeInterval(timeout)))
        taskCard.tap()
        
        let doneButton = app.buttons["btn_add_task_done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(doneButton.isEnabled)
        
        XCTAssertTrue(app.staticTexts["txt_add_tasks_assign_to"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_add_task_selected_user"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_add_tasks_due"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_add_task_select_date"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_create_task_description"].waitForExistence(timeout: TimeInterval(timeout)))
        
        doneButton.tap()
    }
    
    func testDeleteTask() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToTaskSection(app: app)
        
        let card1Description = app.staticTexts["txt_account_detail_task_description_\(accountIndex)"].label
        
        let threeDotButtonForTask2 = app.buttons["btn_account_detail_task_more_\(accountIndex)"]
        XCTAssertTrue(threeDotButtonForTask2.waitForExistence(timeout: TimeInterval(timeout)))
        threeDotButtonForTask2.tap()
        
        let deleteButtonForTask2 = app.buttons["btn_account_detail_delete_task_\(accountIndex)"]
        XCTAssertTrue(deleteButtonForTask2.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButtonForTask2.tap()
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButton.tap()
        
        XCTAssertNotEqual(card1Description, app.staticTexts["txt_account_detail_task_description_\(accountIndex)"].label)
    }
    
    func testEditTask() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToTaskSection(app: app)
        
        app.buttons["btn_account_detail_task_more_\(accountIndex)"].tap()
        
        app.buttons["btn_account_detail_edit_task_\(accountIndex)"].tap()
        
        let addNoteTextField = app.textViews["et_create_task"]
        XCTAssertTrue(addNoteTextField.waitForExistence(timeout: TimeInterval(timeout)))
        // Type Text into the the text field
        addNoteTextField.typeText("Create new task.\nTap on the save button to save it to salesforce.")
        
        app.buttons["btn_save_task"].tap()
    }
    
    func testDeleteTaskError() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "deleteTaskError"]
        app.launch()
        
        // Set the timeout duration
        let timeout = 5
        let accountIndex = 0
        
        navigationToTaskSection(app: app)
        
        let descriptionForTask1 = app.staticTexts["txt_account_detail_task_description_\(accountIndex)"].label
        
        let threeDotButtonForTask1 = app.buttons["btn_account_detail_task_more_\(accountIndex)"]
        XCTAssertTrue(threeDotButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        threeDotButtonForTask1.tap()
        
        let deleteButtonForTask1 = app.buttons["btn_account_detail_delete_task_0"]
        XCTAssertTrue(deleteButtonForTask1.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButtonForTask1.tap()
        
        let deleteButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: TimeInterval(timeout)))
        deleteButton.tap()
        
        // Check whether on error the toast is received
        XCTAssertTrue(app.staticTexts["toast_view_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let descriptionForTask1AfterDelete = app.staticTexts["txt_account_detail_task_description_0"].label
        
        // Verify the task description for 1st task before and after delete are same
        XCTAssertEqual(descriptionForTask1, descriptionForTask1AfterDelete)
    }
}
