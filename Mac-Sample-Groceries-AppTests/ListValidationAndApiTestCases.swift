//
//  ListValidationAndApiTestCases.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import XCTest
@testable import Mac_Sample_Groceries_App

final class ListValidationAndApiTestCases: XCTestCase {
    
    var validation = ListValidation()
    var apiManager = ApiManager()
    
    func testListValidationWithListNameEmpty() throws {
        let request = CreateListInput(listName: "", userID: "1")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "List Name required.")
    }
    
    func testListValidationWithUserIDEmpty() throws {
        let request = CreateListInput(listName: "List Name", userID: "")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "User Id required.")
    }
    
    func testCreateListAPIWithUserIDEmpty() {
        let input = CreateListInput(listName: "List Name", userID: "") //15521C72-A992-40C8-A278-E5D7ADE3F3DD
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.listcreate)!
        let expectation = self.expectation(description: "CreateListAPIWithUserIDEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Data corrupted at path 'userID'. Attempted to decode UUID from invalid UUID string.")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("List Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateListAPIWithListNameEmpty() {
        let input = CreateListInput(listName: "", userID: "15521C72-A992-40C8-A278-E5D7ADE3F3DD")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.listcreate)!
        let expectation = self.expectation(description: "CreateListAPIWithListNameEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "List Name is required")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("List Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateListAPIWithValidDetails() {
        let input = CreateListInput(listName: "List Name", userID: "15521C72-A992-40C8-A278-E5D7ADE3F3DD")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.listcreate)!
        let expectation = self.expectation(description: "CreateListAPIWithValidDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "List Name List Created Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("List Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetListByUserIdAPI() {
        let input = GetListItemInput(userId: "15521C72-A992-40C8-A278-E5D7ADE3F3DD")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.getlistbyuserid)!
        let expectation = self.expectation(description: "GetListByUserId")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "List Retrieved Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("GetListByUserId failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetListByUserIdAPIWithEmptyUserId() {
        let input = GetListItemInput(userId: "")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.getlistbyuserid)!
        let expectation = self.expectation(description: "GetListByUserId")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Data corrupted at path 'userId'. Attempted to decode UUID from invalid UUID string.")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("GetListByUserId failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpdateListAPIWithValidDetails() {
        let input = UpdateListInput(listName: "Good", id: "37bd3747-ad2f-4b97-8705-18555dc7a9ec")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.listupdate)!
        let expectation = self.expectation(description: "UpdateListAPIWithValidDetails")
        
        apiManager.patch(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "List Updated Successfully with name : \(input.listName)")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("List Update API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteListAPIWithValidDetails() {
        let input = DeleteListInput(id: "543dc6e4-e718-43ee-a45f-796f6dfef61c")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.listdelete)!
        let expectation = self.expectation(description: "DeleteListAPIWithValidDetails")
        
        apiManager.delete(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "List Deleted Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("List Delete API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
