//
//  LoginValidationTest.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 25/07/24.
//

import XCTest
import SwiftUI
@testable import Mac_Sample_Groceries_App

final class LoginValidationTest: XCTestCase {
    var validation = LoginValidation()
    
    func testLoginValidationWithEmptyData() throws {
        // Given
        let request = LoginInput(email: "", password: "")
        
        // When
        let result = validation.validateFields(request: request)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Please enter all fields")
    }
    
    func testLoginValidationWithEmailEmpty() throws {
        // Given
        let request = LoginInput(email: "", password: "password")
        
        // When
        let result = validation.validateFields(request: request)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Email required.")
    }
    
    func testLoginValidationWithInvalidEmail() throws {
        // Given
        let request = LoginInput(email: "InvalidEmail", password: "")
        
        // When
        let result = validation.validateFields(request: request)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Please enter a valid email address.")
    }
    
    func testLoginValidationWithPasswordEmpty() throws {
        // Given
        let request = LoginInput(email: "viswanadh.n@krify.com", password: "")
        
        // When
        let result = validation.validateFields(request: request)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Password required.")
    }
    
    func testLoginValidationWithValidDetails() throws {
        // Given
        let request = LoginInput(email: "viswanadh.n@krify.com", password: "krify")
        
        // When
        let result = validation.validateFields(request: request)
        
        // Then
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.message)
    }
    
}
