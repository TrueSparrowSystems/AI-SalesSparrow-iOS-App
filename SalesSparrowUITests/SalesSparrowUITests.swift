//
//  SalesSparrowUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 31/07/23.
//

import XCTest

final class SalesSparrowUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLoginScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests","loggedOutUser"]
        app.launch()
        
        let timeout = 2
        let salesforceConnectButton = app.buttons["btn_connect_salesforce"]
        XCTAssertTrue(salesforceConnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        salesforceConnectButton.tap()
        app.activate()
        
    }
    
    func testSearchAccountOnHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "userLoggedIn"]
        app.launch()
        
        let timeout = 2
        // click on search icon home page
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        // modal should open with empty text box
        let textFieldSearchAccount = app.textFields["text_field_search_account"]
        XCTAssertTrue(textFieldSearchAccount.waitForExistence(timeout: TimeInterval(timeout)))
        let textFieldSearchAccountVal = textFieldSearchAccount.value as? String
        XCTAssertTrue(((textFieldSearchAccountVal?.isEmpty) != nil))
        
        // modal should open with default data
        let accountName = "Test Data 1"
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchAccountNameBtn.isEnabled)
        
        // there should be add note button in it
        let btnSearchAddNoteBtn = app.buttons["btn_search_add_note_\(accountName)"]
        XCTAssertTrue(btnSearchAddNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(btnSearchAddNoteBtn.isEnabled)
        
    }
    
    func testSearchAccountWithQueryOnHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "userLoggedIn", "searchResponseWithQuery"]
        app.launch()
        
        let timeout = 2
        // click on search icon home page
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        // modal should open with empty text box
        let textFieldSearchAccount = app.textFields["text_field_search_account"]
        XCTAssertTrue(textFieldSearchAccount.waitForExistence(timeout: TimeInterval(timeout)))
        textFieldSearchAccount.tap()
        textFieldSearchAccount.typeText("Mock Account")
        XCTAssertEqual(textFieldSearchAccount.value as! String, "Mock Account")
        
        // modal should open with default data
        let accountName = "Mock Account 1"
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // Account row should be clickable
        XCTAssertTrue(btnSearchAccountNameBtn.isEnabled)
        
        // there should be add note button in it
        let btnSearchAddNoteBtn = app.buttons["btn_search_add_note_\(accountName)"]
        XCTAssertTrue(btnSearchAddNoteBtn.waitForExistence(timeout: TimeInterval(timeout)))
        // add note should be clickable
        XCTAssertTrue(btnSearchAddNoteBtn.isEnabled)
        
        
    }
    
    func openAccountDetailUsingSearch(app: XCUIApplication,accountName: String = "Test Data 1") {
        let timeout = 2
        let searchAccountButton = app.images["btn_search_account"]
        XCTAssertTrue(searchAccountButton.waitForExistence(timeout: TimeInterval(timeout)))
        searchAccountButton.tap()
        
        // modal should open with default data
        let btnSearchAccountNameBtn = app.buttons["btn_search_account_name_\(accountName)"]
        XCTAssertTrue(btnSearchAccountNameBtn.waitForExistence(timeout: TimeInterval(timeout)))
        btnSearchAccountNameBtn.tap()
    }
    
    func testAccountDetailHeader() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Open the account detail using the helper function
        openAccountDetailUsingSearch(app: app)
        
        let timeout = 5
        // Check the account icon
        XCTAssertTrue(app.images["img_account_detail_account_icon"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account details title
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_details_title"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account text
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account name text
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_name"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the notes icon
        XCTAssertTrue(app.images["img_account_detail_note_icon"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the notes title
        XCTAssertTrue(app.staticTexts["txt_account_detail_notes_title"].waitForExistence(timeout: TimeInterval(timeout)))
        
        sleep(5)
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
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_note_creator"].waitForExistence(timeout: TimeInterval(timeout)))
        
        XCTAssertTrue(app.staticTexts["txt_account_detail_note_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
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
        
        let firstNoteCard = app.buttons["note_card_100"] // Replace "100" with the appropriate index
        // Check if the note card exists
        XCTAssertTrue(firstNoteCard.waitForExistence(timeout: TimeInterval(timeout)))
        // Tap the note card to view it
        firstNoteCard.tap()
        
        // check if you are on the note detail screen by checking appropriate elements
        
        // check the done button
        let doneButton = app.staticTexts["btn_done_note_screen"]
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
        
        let accountName = "Test Data 1"
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
        addNoteTextField.typeText("Create A New Note")
        
        //Check if the save button is enabled
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        let doneButton = app.staticTexts["btn_done_create_note"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(doneButton.isEnabled)
        
    }
    
    func openUserAccountDetailScreen(app: XCUIApplication){
        let timeout = 2
        
        let userAccountDetailIcon = app.buttons["txt_user_account_icon"]
        XCTAssertTrue(userAccountDetailIcon.waitForExistence(timeout: TimeInterval(timeout)))
        userAccountDetailIcon.tap()
    }
    
    func testUserAccountScreen(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // modal should open with default data
        let timeout = 5
        
        openUserAccountDetailScreen(app: app)
                
        //Check if dismiss Icon is loaded
        let dismissButton = app.images["img_user_account_detail_dismiss"]
        XCTAssertTrue(dismissButton.waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check if username exists
        let userName = app.staticTexts["txt_user_account_detail_user_name"]
        XCTAssertTrue(userName.waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check if disconnect button is rendered and tappable
        let salesforceDisconnectButton = app.buttons["img_user_account_detail_salesforce_disconnect"]
        XCTAssertTrue(salesforceDisconnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(salesforceDisconnectButton.isHittable)
        
        // Check if logout button is visible and tappable
        let logoutButton = app.staticTexts["btn_user_account_detail_logout"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(logoutButton.isHittable)
    }
    
    func testLogoutFlow(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // modal should open with default data
        let timeout = 5
        
        openUserAccountDetailScreen(app: app)
        
        // Check if logout button is visible
        let logoutButton = app.staticTexts["btn_user_account_detail_logout"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(logoutButton.isHittable)
        logoutButton.tap()
        
        // Check if login button is visible
        let salesforceConnectButton = app.buttons["btn_connect_salesforce"]
        XCTAssertTrue(salesforceConnectButton.waitForExistence(timeout: TimeInterval(timeout)))
    }
    
    func testUserAccountDisconnectFlow(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // modal should open with default data
        let timeout = 5
        
        openUserAccountDetailScreen(app: app)
        
        // Check if logout button is visible
        let salesforceDisconnectButton = app.buttons["img_user_account_detail_salesforce_disconnect"]
        XCTAssertTrue(salesforceDisconnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(salesforceDisconnectButton.isHittable)
        salesforceDisconnectButton.tap()
        
        // Check if disconnect modal is visible
        // text, cancel and disconnect button
        XCTAssertTrue(app.staticTexts["txt_user_account_detail_message"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let closeButton = app.buttons["btn_user_account_detail_disconnect"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(closeButton.isHittable)
        
        let disconnectButton = app.buttons["btn_user_account_detail_disconnect"]
        XCTAssertTrue(disconnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(disconnectButton.isHittable)
//        disconnectButton.tap()
    }
    
    func testCreateNoteScreen(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        let timeout = 2
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
        
        let selectAccount = app.staticTexts["btn_select_account"]
        XCTAssertTrue(selectAccount.waitForExistence(timeout: TimeInterval(timeout)))
        // select should be clickable
        XCTAssertTrue(selectAccount.isEnabled)
        selectAccount.tap()
        
        let accountName = "Test Data 1"
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
        
        let doneButton = app.staticTexts["btn_done_create_note"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: TimeInterval(timeout)))
        // cancel should be clickable
        XCTAssertTrue(doneButton.isEnabled)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
