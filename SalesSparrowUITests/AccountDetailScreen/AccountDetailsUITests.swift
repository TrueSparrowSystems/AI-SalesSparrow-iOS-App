//
//  AccountDetailsUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//

import XCTest

final class AccountDetailsUITests: XCTestCase {
    func testAccountDetailHeader() throws {
        // Launch the app with the specified launch arguments
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Replace with the index of the row you want to test
        let rowIndex = 0
        
        // Tap on the account card at the specified index
        let accountCard = app.buttons["account_card_\(rowIndex)"]
        XCTAssertTrue(accountCard.exists, "Account card should be present")
        accountCard.tap()
        
        let timeout = 2
        // Check the account icon
        XCTAssertTrue(app.images["img_account_detail_account_icon"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account details title
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_details_title"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account text
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_text"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // Check the account name text
        XCTAssertTrue(app.staticTexts["txt_account_detail_account_name"].waitForExistence(timeout: TimeInterval(timeout)))
        
        // click on more details if exists
        XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_Website"].waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(app.staticTexts["txt_account_detail_field_value_Website"].waitForExistence(timeout: TimeInterval(timeout)))
//        let btnAccountDetailMoreDetails = app.buttons["btn_account_detail_more_details"]
//        XCTAssertTrue(btnAccountDetailMoreDetails.exists, "More details button not visible")
//        btnAccountDetailMoreDetails.tap()
//        
//        XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_ppt"].waitForExistence(timeout: TimeInterval(timeout)))
//        XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_account_source"].waitForExistence(timeout: TimeInterval(timeout)))
//        XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_hq"].waitForExistence(timeout: TimeInterval(timeout)))
//        XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_status"].waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
        func testAccountContactDetail() throws {
            // Launch the app with the specified launch arguments
            let app = XCUIApplication()
            app.launchArguments = ["isRunningUITests"]
            app.launch()
            
            // Replace with the index of the row you want to test
            let rowIndex = 0
            
            // Tap on the account card at the specified index
            let accountCard = app.buttons["account_card_\(rowIndex)"]
            XCTAssertTrue(accountCard.exists, "Account card should be present")
            accountCard.tap()
            
            
            let timeout = 2
            // Check the contact icon
            XCTAssertTrue(app.images["img_account_detail_contact_icon"].waitForExistence(timeout: TimeInterval(timeout)))
            
            // Check the contact details title
            XCTAssertTrue(app.staticTexts["txt_account_detail_contact_details_title"].waitForExistence(timeout: TimeInterval(timeout)))
            
            // Check the contact number, name and other details
            XCTAssertTrue(app.staticTexts["txt_account_detail_contact_number_index_\(rowIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
            
            XCTAssertTrue(app.staticTexts["txt_account_detail_contact_name_index_\(rowIndex)"].waitForExistence(timeout: TimeInterval(timeout)))
            
            XCTAssertTrue(app.staticTexts["txt_account_list_contact_title_index_0"].waitForExistence(timeout: TimeInterval(timeout)))
            XCTAssertTrue(app.staticTexts["txt_account_list_account_email_index_0"].waitForExistence(timeout: TimeInterval(timeout)))
//            XCTAssertTrue(app.staticTexts["txt_account_detail_field_type_linkedin"].waitForExistence(timeout: TimeInterval(timeout)))
        }
}
