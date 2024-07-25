//
//  VerifyEmailView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 22/07/24.
//

import SwiftUI

struct VerifyEmailView: View {
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @StateObject var toastManager = ToastManager()
    @State private var isLoading: Bool = false
    @StateObject private var authManager = AuthManager()
    @State private var navigateToListView = false

    
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Image("cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geo.size.width * 0.5, 400))
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.leading)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Text("Verify Your Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack(spacing :20) {
                            CustomTextField(placeholder: "Email", text: $email, isSecure: false)
                        }
                        .padding()
                        .background(Color(NSColor.windowBackgroundColor))
                        .cornerRadius(15.0)
                        
                        if isLoading{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Button {
                                if validateFields() {
                                    verifyEmail(input: EmailVerifyInput(email: email))
                                }else {
                                    toastManager.show(message: toastManager.message, type: .error)
                                }
                            } label: {
                                Text("Verify")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(15.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
//                        HStack {
//                            Text("Already have an account?")
//                                .foregroundColor(.gray)
//                            Button(action: {
//                                self.presentationMode.wrappedValue.dismiss()
//                            }) {
//                                Text("Login")
//                                    .foregroundColor(.blue)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
                        
                        Spacer()
                    }
                    .padding()
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .navigationTitle("Verify Email")
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .navigationDestination(isPresented: $navigateToListView) {
                if let user = authManager.getUserFromDefaults(), user.isVerified == true {
                    ListView(userObj: user)
                }
            }
        }
    }
    
    private func validateFields() -> Bool {
        if email.isEmpty {
            toastManager.show(message: "Email required.", type: .error)
            return false
        }
        else if !isValidEmail(email) {
            toastManager.show(message: "Please enter a valid email address.", type: .error)
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func verifyEmail(input: EmailVerifyInput) {
        isLoading = true
//        let emailVerifyUrl = URL(string: "http://127.0.0.1:8080/users/verify")!
        let emailVerifyUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.verify)!
        
        ApiManager.shared.post(url: emailVerifyUrl, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    toastManager.show(message: "Email Verified Successful!", type: .success)
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
                    navigateToListView = true
                    clearAllFields([$email])
                } else {
                    toastManager.show(message: "Email Verification Failed : \(response.message)" , type: .warning)
                }
                
            case .failure(let error):
                print("Registration failed: \(error.localizedDescription)")
                isLoading = false
                toastManager.show(message: "Login failed: \(error.localizedDescription)", type: .error)
            }
        }
    }
}

#Preview {
    VerifyEmailView()
}
