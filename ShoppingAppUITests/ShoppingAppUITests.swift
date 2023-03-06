//
//  ShoppingAppUITests.swift
//  

import XCTest

final class ShoppingAppUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    override func tearDownWithError() throws {
    }

    func testToVerifyAuthPageItems() throws {
        appLaunch()
    }
    
    func testAuthUsingEmptyUsernameAndPassword() throws {
        appLaunch()
        fill(with: "", password: "")
        let expectation = self.expectation(description: "Username or Password cannot be empty")
        XCTAssertTrue(app.staticTexts["Username or Password cannot be empty"].exists)
        if app.staticTexts["Username or Password cannot be empty"].exists {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuthUsingEmptyPassword() throws {
        appLaunch()
        fill(with: "wjohn", password: "")
        let expectation = self.expectation(description: "Username or Password cannot be empty")
        XCTAssertTrue(app.staticTexts["Username or Password cannot be empty"].exists)
        if app.staticTexts["Username or Password cannot be empty"].exists {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuthUsingWrongUsername() throws {
        appLaunch()
        fill(with: "wjoh", password: "1234")
        let expectation = self.expectation(description: "The username or password is incorrect")
        XCTAssertTrue(app.staticTexts["The username or password is incorrect"].exists)
        if app.staticTexts["The username or password is incorrect"].exists {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuthUsingWrongPassword() throws {
        appLaunch()
        fill(with: "wjohn", password: "1111")
        let expectation = self.expectation(description: "The username or password is incorrect")
        XCTAssertTrue(app.staticTexts["The username or password is incorrect"].exists)
        if app.staticTexts["The username or password is incorrect"].exists {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuthUsingCorrectUsernameAndPassword() throws {
        appLaunch()
        fill(with: "wjohn", password: "1234")
        let expectation = self.expectation(description: "Auth_Success")
        if app.navigationBars["Home"].exists {
            expectation.fulfill()
            app.navigationBars["Home"].buttons["person.fill"].tap()
            XCTAssertTrue(app.navigationBars["Profile"].exists)
            app.buttons["LOG OUT"].tap()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testToNavigateToDetailPage() throws {
        appLaunch()
        fill(with: "wjohn", password: "1234")
        let expectation = self.expectation(description: "Nav_Success")
        if app.navigationBars["Home"].exists {
            app.collectionViews.staticTexts["Fine Fragrance Mist"].tap()
            XCTAssertTrue(app.navigationBars["Detail"].staticTexts["Detail"].exists)
            expectation.fulfill()
            XCTAssertTrue(app.scrollViews.otherElements.staticTexts["VICTORIA'S SECRET"].exists)
            XCTAssertTrue(app.scrollViews.otherElements.staticTexts["VICTORIA'S SECRET"].exists)
            app.scrollViews.otherElements.containing(.staticText, identifier:"VICTORIA'S SECRET").element.swipeUp()
            XCTAssertTrue(app.scrollViews.otherElements.staticTexts["ADD TO CART"].exists)
            app.scrollViews.otherElements.staticTexts["ADD TO CART"].tap()
            app.buttons["ADD MORE"].tap()
            XCTAssertTrue(app.navigationBars["Home"].exists)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func appLaunch() {
        app.launch()
        app.wait(for: .runningBackground, timeout: 5)
        if app.navigationBars["Home"].exists {
            app.navigationBars["Home"].buttons["person.fill"].tap()
            XCTAssertTrue(app.navigationBars["Profile"].exists)
            app.buttons["LOG OUT"].tap()
        }
        XCTAssertTrue(app.staticTexts["Username"].exists)
        XCTAssertTrue(app.staticTexts["Password"].exists)
        XCTAssertTrue(app.staticTexts["Password"].exists)
        XCTAssertTrue(app.buttons["SIGN IN"].exists)
    }
    
    private func fill(with username: String, password: String) {
        app.otherElements["Username"].tap()
        app.textFields["Username"].typeText(username)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.otherElements["Password"].tap()
        app.secureTextFields["Password"].typeText(password)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["SIGN IN"].tap()
        app.wait(for: .runningBackground, timeout: 1)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric(), XCTCPUMetric(), XCTClockMetric(), XCTMemoryMetric(), XCTStorageMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
