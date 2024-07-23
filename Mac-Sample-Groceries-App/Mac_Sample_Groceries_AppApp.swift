//
//  Mac_Sample_Groceries_AppApp.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 11/07/24.
//

import SwiftUI

@main
struct Mac_Sample_Groceries_AppApp: App {
    @StateObject private var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                ListView(userObj: authManager.user!)
                    .frame(width: 800, height: 800)
            } else {
                LoginView()
                    .frame(width: 800, height: 800)
            }
        }
    }
}


