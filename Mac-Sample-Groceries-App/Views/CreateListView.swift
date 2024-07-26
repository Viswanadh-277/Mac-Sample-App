//
//  CreateListView.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 20/07/24.
//

import SwiftUI

struct CreateListView: View {
    var userObj : UserDetails
    @State private var newName: String = ""
    var action: (CreateListInput) -> Void
    @StateObject var toastManager = ToastManager()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                CustomTextField(placeholder: "List Name", text: $newName)
                    .padding()
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(15)
                
                Button(action: {
                    let newItem = CreateListInput(listName: newName, userID: userObj.id ?? "")
                    let result = ListValidation().validateFields(request: newItem)
                    if result.isValid == true {
                        action(newItem)
                    } else {
                        toastManager.show(message: result.message ?? "", type: .error)
                    }
                }) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 100)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
                .padding()
                .buttonStyle(PlainButtonStyle())
                .shadow(radius: 10)
            
            }
            .padding()
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func validateFields() -> Bool {
        if newName.isEmpty {
            toastManager.show(message: "List Name required.", type: .error)
            return false
        }
        
        return true
    }
}

#Preview {
    CreateListView(userObj: UserDetails(username: "", isVerified: false, phoneNumber: "", lastName: "", id: "", passwordHash: "", firstName: "", email: "")) { _ in
        print("Created new item")
    }
}
