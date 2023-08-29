//
//  AccountListUITests.swift
//  SalesSparrowUITests
//
//  Created by Mohit Charkha on 24/08/23.
//


import XCTest

final class AccountListUITests: XCTestCase {
    
    func testAccountListPagination(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        let timeout = 2
        
        var availableScrollTries = 3
        
        var scrollView = app.collectionViews["account_list_scroll_view"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: TimeInterval(timeout)))
        
        var lastCard = app.buttons["account_card_14"]
        while !lastCard.exists && availableScrollTries > 0{
            availableScrollTries -= 1
            app.swipeUp()
        }
        
        availableScrollTries = 3
        
        var paginatedCard = app.buttons["account_card_25"]
        while !paginatedCard.exists && availableScrollTries > 0{
            availableScrollTries -= 1
            app.swipeUp()
        }
        XCTAssertTrue(paginatedCard.waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    func testAccountListWithoutPagination(){
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests", "AccountListWithoutPagination"]
        app.launch()
        
        let timeout = 2
        
        var availableScrollTries = 10
        
        var scrollView = app.collectionViews["account_list_scroll_view"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: TimeInterval(timeout)))
        
        var lastCard = app.buttons["account_card_14"]
        while !lastCard.exists && availableScrollTries > 0{
            availableScrollTries -= 1
            app.swipeUp()
        }
        
        availableScrollTries = 10
        
        var paginatedCard = app.buttons["account_card_25"]
        while !paginatedCard.exists && availableScrollTries > 0{
            availableScrollTries -= 1
            app.swipeUp()
        }
        XCTAssertTrue(paginatedCard.waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
}
