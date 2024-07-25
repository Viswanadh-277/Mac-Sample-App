//
//  Mac_Sample_Groceries_UIAppTestsLaunchTests.swift
//  Mac-Sample-Groceries-UIAppTests
//
//  Created by KSMACMINI-016 on 25/07/24.
//

import XCTest

final class Mac_Sample_Groceries_UIAppTestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
