//
//  LoginApiTestCases.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import XCTest
@testable import Mac_Sample_Groceries_App

final class LoginApiTestCases: XCTestCase {
    var apiManager = ApiManager()
    
    func testLoginAPIWithValidDetails() {
        let input = LoginInput(email: "viswanadh.n@krify.com", password: "krify")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.login)!
        let expectation = self.expectation(description: "LoginAPIWithValidDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Login successful")
                XCTAssertEqual(input.email, success.data?.email)
                XCTAssertEqual("Viswa7893", success.data?.username)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Login API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginAPIWithEmailEmpty() {
        let input = LoginInput(email: "", password: "krify")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.login)!
        let expectation = self.expectation(description: "LoginAPIWithEmailEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Email is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Login API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginAPIWithPasswordEmpty() {
        let input = LoginInput(email: "viswanadh.n@krify.com", password: "")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.login)!
        let expectation = self.expectation(description: "LoginAPIWithPasswordEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("Password is required", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Login API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginAPIWithInvalidDetails() {
        let input = LoginInput(email: "viswanadh", password: "krify")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.login)!
        let expectation = self.expectation(description: "LoginAPIWithInvalidDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual("User not found", success.message)
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Login API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
