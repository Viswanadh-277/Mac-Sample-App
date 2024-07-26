//
//  ItemsValidationAndApiTestCases.swift
//  Mac-Sample-Groceries-AppTests
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import XCTest
@testable import Mac_Sample_Groceries_App

final class ItemsValidationAndApiTestCases: XCTestCase {
    
    var validation = ItemsValidation()
    var apiManager = ApiManager()
    
    func testItemsValidationWithItemNameEmpty() throws {
        let request = CreateItemListInput(itemName: "", quantity: "1", listID: "12")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Item Name required.")
    }
    
    func testItemsValidationWithQuantityEmpty() throws {
        let request = CreateItemListInput(itemName: "Item name", quantity: "", listID: "12")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "Quantity required.")
    }
    
    func testItemsValidationWithListIdEmpty() throws {
        let request = CreateItemListInput(itemName: "Item name", quantity: "1", listID: "")
        
        let result = validation.validateFields(request: request)
        
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "List Id required.")
    }
    
    func testCreateItemAPIWithListIDEmpty() {
        let input = CreateItemListInput(itemName: "Jelly", quantity: "10", listID: "")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.itemslistcreate)!
        let expectation = self.expectation(description: "CreateItemAPIWithListIDEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Data corrupted at path 'listID'. Attempted to decode UUID from invalid UUID string.")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Item Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateItemAPIWithQuantityEmpty() {
        let input = CreateItemListInput(itemName: "Jelly", quantity: "", listID: "1BD0C8F1-BD4A-4345-91B1-7A0E1697983D")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.itemslistcreate)!
        let expectation = self.expectation(description: "CreateItemAPIWithQuantityEmpty")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Quantity is required")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Item Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateItemAPIWithValidDetails() {
        let input = CreateItemListInput(itemName: "Books", quantity: "10", listID: "1BD0C8F1-BD4A-4345-91B1-7A0E1697983D")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.itemslistcreate)!
        let expectation = self.expectation(description: "CreateItemAPIWithValidDetails")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "\(input.itemName) Item List Created Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Item Create API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetItemByListIdAPI() {
        let input = GetItemsListInput(listId: "1BD0C8F1-BD4A-4345-91B1-7A0E1697983D")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.getitemsforlistId)!
        let expectation = self.expectation(description: "GetItemByListId")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Items for List Retrieved Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("GetItemByListId failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetItemsByListIdAPIWithEmptyListId() {
        let input = GetItemsListInput(listId: "")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.getitemsforlistId)!
        let expectation = self.expectation(description: "GetItemsByListIdAPIWithEmptyListId")
        
        apiManager.post(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Data corrupted at path 'listId'. Attempted to decode UUID from invalid UUID string.")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("GetListByUserId failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpdateItemsAPIWithValidDetails() {
        let input = UpdateItemListInput(itemName: "Kaju", quantity: "5Kgs", id: "aae3363a-8a37-411c-b48e-bdcf3ad5f0dd")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.itemslistupdate)!
        let expectation = self.expectation(description: "UpdateListAPIWithValidDetails")
        
        apiManager.patch(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Item List Updated Successfully with name : \(input.itemName)")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Item Update API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteItemAPIWithValidDetails() {
        let input = DeleteItemListInput(id: "aae3363a-8a37-411c-b48e-bdcf3ad5f0dd")
        let url = URL(string: APIEndpoints.BASEURL + APIEndpoints.itemslistdelete)!
        let expectation = self.expectation(description: "DeleteItemAPIWithValidDetails")
        
        apiManager.delete(url: url, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
                XCTAssertEqual(success.message, "Item List Deleted Successfully")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Item Delete API failed with error: \(failure.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
