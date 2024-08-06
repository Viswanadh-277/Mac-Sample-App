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
        if let user = DatabaseManager.shared.fetchUser() {
            self.user = user
            self.isLoggedIn = true
        }
    }
    
    func saveUserDetails(_ user: UserDetails) {
        DatabaseManager.shared.insertUser(user: user)
        DispatchQueue.main.async {
            self.user = user
            self.isLoggedIn = true
        }
    }
    
    func logout() {
        DatabaseManager.shared.deleteUser(byID: user?.id ?? "")
        DispatchQueue.main.async {
            self.user = nil
            self.isLoggedIn = false
        }
        DatabaseManager.shared.deleteAllTables()
    }
}
