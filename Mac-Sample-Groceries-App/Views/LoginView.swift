//
//  ContentView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 11/07/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthManager()
    @State var email: String = ""
    @State var password: String = ""
    @State var showRegistrationView: Bool = false
    @State var navigateToActiveAccount: Bool = false
    @State var isLoading: Bool = false
    @State var navigateToListView = false
    @StateObject private var toastManager = ToastManager()
    
    init(authManager: AuthManager = AuthManager(), toastManager: ToastManager = ToastManager()) {
            _authManager = StateObject(wrappedValue: authManager)
            _toastManager = StateObject(wrappedValue: toastManager)
        }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Image("cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.5, 400))
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.leading)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Text("Welcome")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack(spacing :20) {
                            CustomTextField(placeholder: "Email", text: $email, isSecure: false)
                            CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                        }
                        .padding()
                        .background(Color(NSColor.windowBackgroundColor))
                        .cornerRadius(15.0)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            LoginButton {
                                let input = LoginInput(email: email, password: password)
                                let result = LoginValidation().validateFields(request: input)
                                if result.isValid == true {
                                    login(loginInput: input)
                                }else{
                                    toastManager.show(message: result.message ?? "", type: .error)
                                }
                            }
                        }
                        
                        HStack {
                            Text("Create a New Account?")
                                .foregroundColor(.gray)
                            Button(action: {
                                showRegistrationView = true
                                clearAllFields([$email,$password])
                            }) {
                                Text("Register")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0)
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .navigationBarBackButtonHidden()
                .navigationDestination(isPresented: $showRegistrationView) {
                    RegistrationView()
                }
                .navigationDestination(isPresented: $navigateToListView) {
                    if let user = authManager.user, user.isVerified == true {
                        ListView(userObj: user)
                    }else{
                        VerifyEmailView()
                    }
                }
                .navigationDestination(isPresented: $navigateToActiveAccount) {
                    VerifyEmailView()
                }
            }
        }
        .navigationTitle("Login")
        .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
    }
    
    func validateFields() -> Bool {
        if email.isEmpty {
            toastManager.show(message: "Email required.", type: .error)
            return false
        } else if !isValidEmail(email) {
            toastManager.show(message: "Please enter a valid email address.", type: .error)
            return false
        } else if password.isEmpty {
            toastManager.show(message: "Password required.", type: .error)
            return false
        }
        
        return true
    }
    
    
    func login(loginInput: LoginInput) {
        isLoading = true
        
        let loginUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.login)!
//        let loginUrl = URL(string: "http://127.0.0.1:8080/users/login")!
        ApiManager.shared.post(url: loginUrl, body: loginInput) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                print("Login successful : \(response.message)")
                if response.status == 1 {
//                    toastManager.show(message: "Login successful!", type: .success)
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
                    clearAllFields([$email,$password])
                } else if response.status == 2 {
                    clearAllFields([$email,$password])
                    navigateToListView = true
                    toastManager.show(message: "Login Failed: \(response.message)", type: .warning)
                } else {
                    toastManager.show(message: "Login Failed: \(response.message)", type: .warning)
                }
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                isLoading = false
                toastManager.show(message: "Login failed: \(error.localizedDescription)", type: .error)
            }
        }
    }
}

struct LoginButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Login")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(15.0)
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(15.0)
        .padding(.top, 20)
    }
}

#Preview {
    LoginView()
}
