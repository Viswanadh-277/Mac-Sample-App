//
//  AuthManager.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 22/07/24.
//

import SwiftUI
import Combine

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: UserDetails?

    init() {
        checkUserLoginStatus()
    }

    func checkUserLoginStatus() {
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.string(forKey: "username") {
            let isVerified = userDefaults.bool(forKey: "isVerified")
            let phoneNumber = userDefaults.string(forKey: "phoneNumber") ?? ""
            let lastName = userDefaults.string(forKey: "lastName") ?? ""
            let id = userDefaults.string(forKey: "id") ?? ""
            let passwordHash = userDefaults.string(forKey: "passwordHash") ?? ""
            let firstName = userDefaults.string(forKey: "firstName") ?? ""
            let email = userDefaults.string(forKey: "email") ?? ""

            self.user = UserDetails(username: username, isVerified: isVerified, phoneNumber: phoneNumber, lastName: lastName, id: id, passwordHash: passwordHash, firstName: firstName, email: email)
            self.isLoggedIn = true
        }
    }

    func saveUserDetails(_ user: UserDetails) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.username, forKey: "username")
        userDefaults.set(user.isVerified, forKey: "isVerified")
        userDefaults.set(user.phoneNumber, forKey: "phoneNumber")
        userDefaults.set(user.lastName, forKey: "lastName")
        userDefaults.set(user.id, forKey: "id")
        userDefaults.set(user.passwordHash, forKey: "passwordHash")
        userDefaults.set(user.firstName, forKey: "firstName")
        userDefaults.set(user.email, forKey: "email")
        userDefaults.synchronize()
    }
    
    func getUserFromDefaults() -> UserDetails? {
            let userDefaults = UserDefaults.standard
            let username = userDefaults.string(forKey: "username") ?? ""
            let isVerified = userDefaults.bool(forKey: "isVerified")
            let phoneNumber = userDefaults.string(forKey: "phoneNumber") ?? ""
            let lastName = userDefaults.string(forKey: "lastName") ?? ""
            let id = userDefaults.string(forKey: "id") ?? ""
            let passwordHash = userDefaults.string(forKey: "passwordHash") ?? ""
            let firstName = userDefaults.string(forKey: "firstName") ?? ""
            let email = userDefaults.string(forKey: "email") ?? ""

            return UserDetails(username: username, isVerified: isVerified, phoneNumber: phoneNumber, lastName: lastName, id: id, passwordHash: passwordHash, firstName: firstName, email: email)
        }

    func logout() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "isVerified")
        userDefaults.removeObject(forKey: "phoneNumber")
        userDefaults.removeObject(forKey: "lastName")
        userDefaults.removeObject(forKey: "id")
        userDefaults.removeObject(forKey: "passwordHash")
        userDefaults.removeObject(forKey: "firstName")
        userDefaults.removeObject(forKey: "email")

        self.user = nil
        self.isLoggedIn = false
    }
}
