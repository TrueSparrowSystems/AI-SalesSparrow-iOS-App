//
//  SalesSparrowTests.swift
//  SalesSparrowTests
//
//  Created by Mohit Charkha on 31/07/23.
//

import XCTest
@testable import SalesSparrow

final class SalesSparrowTests: XCTestCase {
    var sut: AppDelegate!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = AppDelegate()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testBasicHelper() throws {
        let double = 12.5
        let doubleToString = BasicHelper.toString(double)
        // Check if the value after conversion of double to string using util function is of type String
        XCTAssertTrue(type(of:doubleToString!) == String.self)
        
        // Check if the value after conversion of double to int using util function is nil
        XCTAssertNil(BasicHelper.toInt(double))
        
        let stringToDouble = BasicHelper.toDouble(doubleToString)
        // Check if the value after conversion of string to double using util function is of type Double
        XCTAssertTrue(type(of: stringToDouble!) == Double.self)
        
        let doubleToDouble = BasicHelper.toDouble(double)
        // Check if the value after conversion of double to double using util function is of type Double
        XCTAssertTrue(type(of:doubleToDouble!) == Double.self)
        // Check if the value before and after conversion of double to double using util function is same
        XCTAssertTrue(doubleToDouble == double)
        
        let int = 10
        let intToString = BasicHelper.toString(int)
        // Check if the value after conversion of int to string using util function is of type String
        XCTAssertTrue(type(of:intToString!) == String.self)
        // Check if the value before and after conversion of int to string using util function is same
        XCTAssertTrue(intToString! == String(int))
        
        let intToInt = BasicHelper.toInt(int)
        // Check if the value after conversion of int to int using util function is of type Int
        XCTAssertTrue(type(of:intToInt!) == Int.self)
        // Check if the value before and after conversion of int to int using util function is same
        XCTAssertTrue(intToInt == int)
        
        let float : Float = -10.2
        let floatToString = BasicHelper.toString(float)
        // Check if the value after conversion of float to string using util function is of type String
        XCTAssertTrue(type(of:floatToString!) == String.self)
        
        XCTAssertNil(BasicHelper.toDouble(float))
        
        let stringToInt = BasicHelper.toInt(intToString)
        // Check if the value after conversion of string to int using util function is of type Int
        XCTAssertTrue(type(of: stringToInt!) == Int.self)
        
        let string = "string"
        let stringToString = BasicHelper.toString(string)
        // Check if the value after conversion of string to string using util function is of type String
        XCTAssertTrue(type(of:stringToString!) == String.self)
        // Check if the value before and after conversion of string to string using util function is same
        XCTAssertTrue(stringToString! == string)
        
        let stringToBool = BasicHelper.toBool(string)
        // Check if the value after conversion of string to bool using util function is false
        XCTAssertFalse(stringToBool)
        
        let bool = false
        let boolToBool = BasicHelper.toBool(bool)
        // Check if the value after conversion of bool to bool using util function is of type Bool
        XCTAssertTrue(type(of: boolToBool) == Bool.self)
        // Check if the value before and after conversion of bool to bool using util function is same
        XCTAssertTrue(boolToBool == bool)
        
        let nilVariable: Any? = nil
        // Check if the value after conversion of nil to bool using util function is false
        XCTAssertFalse(BasicHelper.toBool(nilVariable))
        // Check if the value after conversion of nil to int using util function is nil
        XCTAssertNil(BasicHelper.toInt(nilVariable))
        // Check if the value after conversion of nil to double using util function is nil
        XCTAssertNil(BasicHelper.toDouble(nilVariable))
        // Check if the value after conversion of nil to string using util function is nil
        XCTAssertNil(BasicHelper.toString(nilVariable))
        
        
        let char: Character = "a"
        // Check if the value after conversion of char to string using util function is nil
        XCTAssertNil(BasicHelper.toString(char))
    }
    
    func testGetFormattedDateForCard() throws {
        // 1 Year Ago
        var time = Date(timeInterval: -(370*24*60*60), since: Date())
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        var timeString = dateFormatter.string(from: time)
        var formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "1 year ago")
        
        // 2 Years Ago
        time = Date(timeInterval: -(2*370*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "2 years ago")
        
        // 1 Month Ago
        time = Date(timeInterval: -(31*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "1 month ago")
        
        // 2 Months Ago
        time = Date(timeInterval: -(2*31*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "2 months ago")
        
        // 1 week Ago
        time = Date(timeInterval: -(8*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "1 week ago")
        
        // 2 weeks Ago
        time = Date(timeInterval: -(2*8*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "2 weeks ago")
        
        // Less than a week Ago
        time = Date(timeInterval: -(24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        dateFormatter.dateFormat = "EEEE, hh:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        let dateString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == dateString)
        
        // Just now
        time = Date(timeInterval: -(60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard == "Just now")
        
        // Invalid Date format case
        time = Date(timeInterval: -(31*24*60*60), since: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmaZ"
        timeString = dateFormatter.string(from: time)
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: timeString)
        XCTAssertTrue(formattedDateForCard.isEmpty)
        
        // Invalid Date String
        formattedDateForCard = BasicHelper.getFormattedDateForCard(from: "abcd")
        XCTAssertTrue(formattedDateForCard.isEmpty)
    }
    
    func testGetFormattedDateForDueDate() throws {
        
        //Original dateString to be passed to the function
        var dateString = "2023-07-12"
        //Formatted DateString expected as output from function
        let expectedFormattedDateString = "2023/07/12"
        
        var formattedDateString = BasicHelper.getFormattedDateForDueDate(from: dateString)
        XCTAssertTrue(expectedFormattedDateString == formattedDateString)
        
        //Invalid DateString for error case
        dateString = "2023.7"
        
        formattedDateString = BasicHelper.getFormattedDateForDueDate(from: dateString)
        XCTAssertTrue(formattedDateString.isEmpty)
        
    }
    
    func testGetInitials() throws {
        // 2 word name
        var name = "Abc Xyz"
        var initials = BasicHelper.getInitials(from: name)
        XCTAssertTrue(initials == "AX")
        
        //1 word name
        name = "Abc"
        initials = BasicHelper.getInitials(from: name)
        XCTAssertTrue(initials == "A")
        
        //No name
        name = ""
        initials = BasicHelper.getInitials(from: name)
        XCTAssertTrue(initials == "")
        
        //Long Name
        name = "Abc def Ghi Jkl"
        initials = BasicHelper.getInitials(from: name)
        XCTAssertTrue(initials == "AD")
    }
    
    func testNotificationIsPublishedWithExpectedTitle() throws {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let expectedTitle = "Test Notification"
        let content = UNMutableNotificationContent()
        content.title = expectedTitle
        content.body = "This is a test notification"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            XCTAssertNil(error)
        }

//        let expectation = XCTestExpectation(description: "Notification delivered")
//        center.getDeliveredNotifications { notifications in
//            for notification in notifications {
//                if notification.request.content.title == expectedTitle {
//                    expectation.fulfill()
//                }
//            }
//        }
//
//        wait(for: [expectation], timeout: 5)
    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
