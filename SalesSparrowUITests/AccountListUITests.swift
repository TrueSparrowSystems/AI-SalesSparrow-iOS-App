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
        
        var scrollView = app.scrollViews["account_list_scroll_view"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: TimeInterval(timeout)))
        
        var lastCard = app.buttons["account_card_14"]
        while !lastCard.isHittable{
            app.swipeUp()
        }
        app.swipeUp()
        
        var nextPageLoader = app.images["next_page_loader"]
        XCTAssertTrue(nextPageLoader.waitForExistence(timeout: TimeInterval(timeout)))
        
        var paginatedCard = app.buttons["account_card_20"]
        app.swipeUp()
        XCTAssertTrue(paginatedCard.waitForExistence(timeout: TimeInterval(timeout)))
        
    }
    
}
