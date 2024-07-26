//
//  Validations.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 26/07/24.
//

import Foundation

struct LoginValidation {
    func validateFields(request : LoginInput) -> ValidationResponse {
        if request.email.isEmpty && request.password.isEmpty {
            return ValidationResponse(message: "Please enter all fields", isValid: false)
        } 
        else if request.email.isEmpty && !request.password.isEmpty {
            return ValidationResponse(message: "Email required.", isValid: false)
        } 
        else if isValidEmail(request.email) == false {
            return ValidationResponse(message: "Please enter a valid email address.", isValid: false)
        } 
        else if request.password.isEmpty && !request.email.isEmpty {
            return ValidationResponse(message: "Password required.", isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}

struct SignUpValidation {
    func validateFields(request : RegistrationInput) -> ValidationResponse {
        if request.firstName.isEmpty {
            return ValidationResponse(message: "First Name required.", isValid: false)
        } 
        else if request.username.isEmpty {
            return ValidationResponse(message: "User Name required.", isValid: false)
        }
        else if request.email.isEmpty {
            return ValidationResponse(message: "Email required.", isValid: false)
        }
        else if isValidEmail(request.email) == false {
            return ValidationResponse(message: "Please enter a valid email address.", isValid: false)
        } 
        else if request.phoneNumber.isEmpty {
            return ValidationResponse(message: "Phone Number required.", isValid: false)
        }
        else if isValidPhoneNumber(request.phoneNumber) == false {
            return ValidationResponse(message: "Please enter a valid phone number.", isValid: false)
        }
        else if request.password.isEmpty {
            return ValidationResponse(message: "Password required.", isValid: false)
        }
        else if request.confirmPassword.isEmpty {
            return ValidationResponse(message: "Confirm Password required.", isValid: false)
        }
        else if request.confirmPassword != request.password {
            return ValidationResponse(message: "Passwords do not match.", isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}

struct ListValidation {
    func validateFields(request : CreateListInput) -> ValidationResponse {
        if request.listName.isEmpty {
            return ValidationResponse(message: "List Name required.", isValid: false)
        }
        else if request.userID.isEmpty {
            return ValidationResponse(message: "User Id required.", isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}

struct UpdateListValidation {
    func validateFields(request : UpdateListInput) -> ValidationResponse {
        if request.listName.isEmpty {
            return ValidationResponse(message: "List Name required.", isValid: false)
        }
        else if request.id.isEmpty {
            return ValidationResponse(message: "List Id required.", isValid: false)
        }

        return ValidationResponse(message: nil, isValid: true)
    }
}


struct ItemsValidation {
    func validateFields(request : CreateItemListInput) -> ValidationResponse {
        if request.itemName.isEmpty {
            return ValidationResponse(message: "Item Name required.", isValid: false)
        }
        else if request.quantity.isEmpty {
            return ValidationResponse(message: "Quantity required.", isValid: false)
        }
        else if request.listID.isEmpty {
            return ValidationResponse(message: "List Id required.", isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}

struct UpdateItemsValidation {
    func validateFields(request : UpdateItemListInput) -> ValidationResponse {
        if request.itemName.isEmpty {
            return ValidationResponse(message: "Item Name required.", isValid: false)
        }
        else if request.quantity.isEmpty {
            return ValidationResponse(message: "Quantity required.", isValid: false)
        }
        else if request.id.isEmpty {
            return ValidationResponse(message: "Item Id required.", isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}
