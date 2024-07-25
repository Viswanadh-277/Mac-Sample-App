//
//  GlobalMethods.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 22/07/24.
//

import Foundation
import SwiftUI

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
