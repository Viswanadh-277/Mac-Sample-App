//
//  Models.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 12/07/24.
//

import Foundation

//MARK: - Login
struct LoginInput: Codable {
    let email : String
    let password : String
}
// MARK: - UserData
struct LoginResponse: Codable {
    let status: Int
    let message: String
    var data: UserDetails? = nil
}
// MARK: - DataClass
struct UserDetails: Codable {
    var username: String?
    var isVerified: Bool?
    var phoneNumber, lastName, id, passwordHash: String?
    var firstName, email: String?
}

struct SuccessResponse: Codable {
    let status : Int
    let message : String
}

//MARK: - Registration
struct RegistrationInput: Codable {
    var firstName, lastName, username, email: String
    var phoneNumber, password, confirmPassword: String
}

//MARK: - Email Verification
struct EmailVerifyInput : Codable {
    let email : String
}

//MARK: - Edit User
struct EditUserInput : Codable {
    var userID, firstName, lastName, username, email, phoneNumber : String
}

//MARK: - List View
struct GetListItemInput : Codable {
    let userId : String
}

// MARK: - Getlistbyuserid
struct Getlistbyuserid: Codable {
    var data: [ListData]?
    var message: String
    var status: Int
}

// MARK: - Datum
struct ListData: Codable, Identifiable, Hashable{
    var listName, userID, id: String
}

struct CreateListInput : Codable {
    var listName, userID : String
}

struct UpdateListInput : Codable {
    var listName, id : String
}

struct DeleteListInput : Codable {
    var id : String
}

//MARK: - Items List
struct GetItemsListInput : Codable {
    let listId : String
}

struct GetItemlistById: Codable {
    var data: [ItemListData]?
    var message: String
    var status: Int
}

struct ItemListData: Codable,Identifiable {
    var itemName, listID, quantity, id: String?
}

struct CreateItemListInput : Codable {
    var itemName, quantity, listID : String
}

struct UpdateItemListInput : Codable {
    var itemName, quantity, id : String
}

struct DeleteItemListInput : Codable {
    var id : String
}

struct ValidationResponse {
    let message: String?
    let isValid: Bool
}

//struct ListItem: Identifiable {
//    let id: UUID
//    var name: String
//    var quantity: Int
//}
