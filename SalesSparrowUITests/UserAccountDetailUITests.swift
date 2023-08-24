//
//  UserAccountDetailUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 23/08/23.
//


import XCTest

final class UserAccountDetailsUITests: XCTestCase {
    
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
        XCTAssertTrue(app.staticTexts["txt_alert_message"].waitForExistence(timeout: TimeInterval(timeout)))
        
        let closeButton = app.buttons["btn_alert_cancel"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(closeButton.isHittable)
        
        let disconnectButton = app.buttons["btn_alert_submit"]
        XCTAssertTrue(disconnectButton.waitForExistence(timeout: TimeInterval(timeout)))
        XCTAssertTrue(disconnectButton.isHittable)
        disconnectButton.tap()
        
        // Check if login button is visible
        let salesforceConnectButton = app.buttons["btn_connect_salesforce"]
        XCTAssertTrue(salesforceConnectButton.waitForExistence(timeout: TimeInterval(timeout)))
    }
    
}
