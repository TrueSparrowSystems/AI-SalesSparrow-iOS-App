//
//  AccountListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 24/08/23.
//


import XCTest

final class AccountListUITests: XCTestCase {
    
    func testAccountListWithoutPagination(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        let timeout = 2
        
        var availableScrollTries = 1
        let rowIndex = 3
        let scrollView = app.collectionViews["account_list_scroll_view"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: TimeInterval(timeout)))
        
        let lastCard = app.buttons["account_card_\(rowIndex)"]
        while !lastCard.exists && availableScrollTries > 0{
            availableScrollTries -= 1
            app.swipeUp()
        }
    }
    
    func testAccountRowViewElements() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Replace with the index of the row you want to test
        let rowIndex = 2
        
        let accountName = "Test Account \(rowIndex+1)"
        
        XCTAssertTrue(app.staticTexts["txt_account_list_account_name_index_\(rowIndex)"].exists, "Account name label should be present")
        XCTAssertTrue(app.staticTexts["txt_account_list_account_name_index_\(rowIndex)"].label == accountName)
        
        XCTAssertTrue(app.staticTexts["txt_account_list_account_website_index_\(rowIndex)"].exists, "Website label should be present")
        
        XCTAssertTrue(app.staticTexts["txt_account_list_account_contact_name_index_\(rowIndex)"].exists, "Contact name label should be present")
        
        XCTAssertTrue(app.staticTexts["txt_account_list_account_email_index_\(rowIndex)"].exists, "Contact email label should be present")
    }
    
    func testNavigateToAccountDetailScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch() // Launch your app
        
        // Replace with the index of the row you want to test
        let rowIndex = 0
        
        // Tap on the account card at the specified index
        let accountCard = app.buttons["account_card_\(rowIndex)"]
        XCTAssertTrue(accountCard.exists, "Account card should be present")
        accountCard.tap()
        
        // Check if the screen navigated to the account detail screen
        let accountNameLabel = app.staticTexts["txt_account_detail_account_name"]
        XCTAssertTrue(accountNameLabel.waitForExistence(timeout: 5), "Account name label on detail screen should be present")
        
        let accountDetailsTitleLabel = app.staticTexts["txt_account_detail_account_details_title"]
        XCTAssertTrue(accountDetailsTitleLabel.exists, "Account details title label on detail screen should be present")
    }
}
