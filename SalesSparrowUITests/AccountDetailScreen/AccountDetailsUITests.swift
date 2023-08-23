//
//  AccountDetailsUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//


import XCTest

final class AccountDetailsUITests: XCTestCase {
    
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
}
