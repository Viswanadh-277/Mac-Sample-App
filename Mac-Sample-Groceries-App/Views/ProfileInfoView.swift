//
//  ProfileInfoView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 25/07/24.
//

import SwiftUI

struct ProfileInfoView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var navigateToLogin : Bool = false
    @State private var isLoading: Bool = false
    @StateObject var toastManager = ToastManager()
    @StateObject private var authManager = AuthManager()
    var userObj : UserDetails
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(alignment:.center) {
                    Image("personIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.2 , height: geo.size.height * 0.2)
                    
                    Text("Profile")
                        .padding(.bottom,20)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    FiledsView(firstName: $firstName,
                               lastName: $lastName,
                               username: $username,
                               email: $email,
                               phoneNumber: $phoneNumber)
                    
                    UpdateAndDeleteButtons(spacing: CGFloat(geo.size.width) * 0.05,
                                           navigateToLogin: $navigateToLogin,
                                           authManager: authManager,
                                           editUser: {
                        if validateFields() {
                            let input = EditUserInput(userID: userObj.id ?? "",
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      username: username,
                                                      email: email,
                                                      phoneNumber: phoneNumber)
                            EditUser(input: input)
                        } else {
                            toastManager.show(message: toastManager.message, type: .error)
                        }
                    },
                                           deleteUser: {
                        let input = DeleteItemListInput(id: userObj.id ?? "")
                        DeleteUser(input: input)
                    })
                }
                .padding(50)
                .shadow(radius: 10.0)
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Profile Info")
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .onAppear {
                prefillUserDetails()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
    
    private func validateFields() -> Bool {
        if firstName.isEmpty {
            toastManager.show(message: "First Name required.", type: .error)
            return false
        }
        else if username.isEmpty {
            toastManager.show(message: "User Name required.", type: .error)
            return false
        }
        else if email.isEmpty {
            toastManager.show(message: "Email required.", type: .error)
            return false
        }
        else if !isValidEmail(email) {
            toastManager.show(message: "Please enter a valid email address.", type: .error)
            return false
        }
        else if phoneNumber.isEmpty {
            toastManager.show(message: "Phone Number required.", type: .error)
            return false
        }
        if !isValidPhoneNumber(phoneNumber) {
            toastManager.show(message: "Please enter a valid phone number.", type: .error)
            return false
        }
        return true
    }
    
    private func prefillUserDetails() {
        firstName = userObj.firstName ?? ""
        lastName = userObj.lastName ?? ""
        username = userObj.username ?? ""
        email = userObj.email ?? ""
        phoneNumber = userObj.phoneNumber ?? ""
    }
    
    private func EditUser(input: EditUserInput) {
        isLoading = true
        
        let editUrl = URL(string: "http://127.0.0.1:8080/users/editUser")!
        ApiManager.shared.post(url: editUrl, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    toastManager.show(message: "Updated successfully!", type: .success)
                    let user = UserDetails(username: response.data?.username ?? "",
                                           isVerified: response.data?.isVerified ?? Bool(),
                                           phoneNumber: response.data?.phoneNumber ?? "",
                                           lastName: response.data?.lastName ?? "",
                                           id: response.data?.id ?? "",
                                           passwordHash: response.data?.passwordHash ?? "",
                                           firstName: response.data?.firstName ?? "",
                                           email: response.data?.email ?? "")
                    
                    authManager.saveUserDetails(user)
                    authManager.isLoggedIn = true
                    clearAllFields([$firstName,$lastName,$username,$email,$phoneNumber])
                    
                } else {
                    toastManager.show(message: "Update Failed: \(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "Updated failed: \(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func DeleteUser(input: DeleteItemListInput) {
        isLoading = true
        
        let deleteUrl = URL(string: "http://127.0.0.1:8080/users/deleteUser")!
        ApiManager.shared.post(url: deleteUrl, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    toastManager.show(message: "User Deleted successfully!", type: .success)
                    authManager.isLoggedIn = false
                    navigateToLogin = true
                    clearAllFields([$firstName,$lastName,$username,$email,$phoneNumber])
                } else {
                    toastManager.show(message: "Delete Failed: \(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "Delete failed: \(error.localizedDescription)", type: .error)
            }
        }
    }
    
}

struct UpdateAndDeleteButtons: View {
    var spacing : CGFloat = 0
    @Binding var navigateToLogin: Bool
    @ObservedObject var authManager: AuthManager
    var editUser: () -> Void
    var deleteUser: () -> Void
    
    var body: some View {
        HStack (spacing: spacing){
            CustomButton(title: "Update", customColor: .green) {
                editUser()
            }
            
            CustomButton(title: "Log Out", customColor: .blue) {
                navigateToLogin = true
                authManager.logout()
            }
            
            CustomButton(title: "Delete User") {
                deleteUser()
            }
            
        }
        .padding(.top, 40)
    }
}

struct FiledsView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var username: String
    @Binding var email: String
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack (spacing : 20) {
            CustomTextField(placeholder: "First Name", text: $firstName)
            CustomTextField(placeholder: "Last Name", text: $lastName)
            CustomTextField(placeholder: "User Name", text: $username)
            CustomTextField(placeholder: "Email", text: $email)
            CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(15.0)
    }
}

#Preview(traits: .fixedLayout(width: 800, height: 800)) {
    ProfileInfoView(userObj: UserDetails())
}

