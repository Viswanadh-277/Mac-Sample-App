//
//  SignUpApiTestCases.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import XCTest
@testable import Mac_Sample_Groceries_App

final class SignUpApiTestCases: XCTestCase {
    var apiManager = ApiManager()
   
    func testSignUpAPIWithValidDetails() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithValidDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "User registered successfully for email: \(input.email)")
                XCTAssertEqual(input.email, success.data?.email)
                XCTAssertEqual("username", success.data?.username)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithFirstNameEmpty() {
        let input = RegistrationInput(firstName: "",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithFirstNameEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("First name is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithUserNameEmpty() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithUserNameEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Username is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithEmailEmpty() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithEmailEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Email is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithPhoneNumberEmpty() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithPhoneNumberEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Phone number is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithPasswordEmpty() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithPasswordEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Password is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithConfirmPasswordEmpty() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithConfirmPasswordEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Confirm Password is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpAPIWithAlreadyUsedDetails() {
        let input = RegistrationInput(firstName: "firstName",
                                      lastName: "lastName",
                                      username: "username",
                                      email: "test@example.com",
                                      phoneNumber: "1234567890",
                                      password: "password",
                                      confirmPassword: "password")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        let expectation = self.expectation(description: "SignUpAPIWithAlreadyUsedDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Username, email, or phone number already exists", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Register API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
