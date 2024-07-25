//
//  GlobalMethods.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 22/07/24.
//

import Foundation
import SwiftUI

enum urlType:Int{
    case dev    = 0
    case Live   = 1
}


struct APIEndpoints
{
    static let Environment = urlType.Live
    
    static var BASEURL: String {
        switch Environment {
        case .dev:
            return "http://127.0.0.1:8080"
        case .Live:
            return "http://swiftvapor.krify.com"
        }
    }
    
    //MARK: - User Registration API's
    static let login                                = "/users/login"
    static let register                             = "/users/register"
    static let verify                               = "/users/verify"
    static let allusers                             = "/users/allusers"
    static let deleteUser                           = "/users/deleteUser"
    static let editUser                             = "/users/editUser"
    
    //MARK: - Create List API's
    static let listcreate                           = "/createlist/listcreate"
    static let listupdate                           = "/createlist/listupdate"
    static let listdelete                           = "/createlist/listdelete"
    static let getalllist                           = "/createlist/getalllist"
    static let getlistbyuserid                      = "/createlist/getlistbyuserid"
    
    //MARK: - Items List API's
    static let itemslistcreate                      = "/itemslist/itemslistcreate"
    static let itemslistupdate                      = "/itemslist/itemslistupdate"
    static let itemslistdelete                      = "/itemslist/itemslistdelete"
    static let getallitemslist                      = "/itemslist/getallitemslist"
    static let getitemsforlistId                    = "/itemslist/getitemsforlistId"
}


func clearAllFields(_ fields: [Binding<String>]) {
    for field in fields {
        field.wrappedValue = ""
    }
}

func isValidEmail(_ email: String) -> Bool {
    // Basic email validation
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    // Basic phone number validation
    let phoneRegex = "^\\d{10}$"
    return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
}
