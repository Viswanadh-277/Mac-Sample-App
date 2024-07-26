//
//  SignUpValidationTestCases.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import XCTest
@testable import Mac_Sample_Groceries_App

final class SignUpValidationTestCases: XCTestCase {
    var validation = SignUpValidation()

    func testSignUpValidationWithFirstNameEmpty() {
        let request = RegistrationInput(firstName: "",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "email",
                                        phoneNumber: "phoneNumber",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "First Name required.")
    }
    
    func testSignUpValidationWithUserNameEmpty() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "",
                                        email: "email",
                                        phoneNumber: "phoneNumber",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "User Name required.")
    }
    
    func testSignUpValidationWithEmailEmpty() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "",
                                        phoneNumber: "phoneNumber",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Email required.")
    }
    
    func testSignUpValidationWithInvalidEmail() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "email",
                                        phoneNumber: "phoneNumber",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Please enter a valid email address.")
    }
    
    func testSignUpValidationWithPhoneNumberEmpty() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "viswanadh.n@krify.com",
                                        phoneNumber: "",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Phone Number required.")
    }
    
    func testSignUpValidationWithInvalidPhoneNumber() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "viswanadh.n@krify.com",
                                        phoneNumber: "phoneNumber",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Please enter a valid phone number.")
    }
    
    func testSignUpValidationWithPasswordEmpty() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "viswanadh.n@krify.com",
                                        phoneNumber: "9133951393",
                                        password: "",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Password required.")
    }
    
    func testSignUpValidationWithConfirmPasswordEmpty() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "viswanadh.n@krify.com",
                                        phoneNumber: "9133951393",
                                        password: "password",
                                        confirmPassword: "")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Confirm Password required.")
    }
    
    func testSignUpValidationWithDifferentPasswords() {
        let request = RegistrationInput(firstName: "firstName",
                                        lastName: "lastName",
                                        username: "username",
                                        email: "viswanadh.n@krify.com",
                                        phoneNumber: "9133951393",
                                        password: "password",
                                        confirmPassword: "confirmPassword")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Passwords do not match.")
    }

}

//First Name required.
//User Name required.
//Email required.
//Please enter a valid email address.
//Phone Number required.
//Please enter a valid phone number.
//Password required.
//Confirm Password required.
//Passwords do not match.
