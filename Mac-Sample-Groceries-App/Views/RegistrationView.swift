//
//  RegistrationView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 12/07/24.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss //--> above iOS 15
    @Environment(\.presentationMode) var presentationMode //--> below iOS 15
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State var alertTitle: String = ""
    @StateObject var toastManager = ToastManager()
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
                        
                        Text("Create an Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        RegistrationForm(
                            firstName: $firstName,
                            lastName: $lastName,
                            username: $username,
                            email: $email,
                            phoneNumber: $phoneNumber,
                            password: $password,
                            confirmPassword: $confirmPassword
                        )
                        
                        if isLoading{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            CustomButton(title: "Sign Up") {
                                let input = RegistrationInput(
                                    firstName: firstName,
                                    lastName: lastName,
                                    username: username,
                                    email: email,
                                    phoneNumber: phoneNumber,
                                    password: password,
                                    confirmPassword: confirmPassword)
                                
                                let result = SignUpValidation().validateFields(request: input)
                                if result.isValid == true {
                                    registration(input: input)
                                }else{
                                    toastManager.show(message: result.message ?? "", type: .error)
                                }
                            }
                            .padding(.top, 20)
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Login")
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
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .navigationTitle("Registration")
            .navigationDestination(isPresented: $navigateToListView) {
                if let user = authManager.user, user.isVerified == true {
                    ListView(userObj: user)
                } else {
                    VerifyEmailView()
                }
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
        else if password.isEmpty {
            toastManager.show(message: "Password required.", type: .error)
            return false
        }
        else if confirmPassword.isEmpty {
            toastManager.show(message: "Confirm Password required.", type: .error)
            return false
        }
        else if password != confirmPassword {
            toastManager.show(message: "Passwords do not match.", type: .error)
            return false
        }
        
        return true
    }
    
    private func registration(input:RegistrationInput) {
        isLoading = true
//        let registrationUrl = URL(string: "http://127.0.0.1:8080/users/register")!
        let registrationUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.register)!
        
        ApiManager.shared.post(url: registrationUrl, body: input) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                print("Registration successful : \(response.message)")
                if response.status == 1 {
//                    toastManager.show(message: "Registration Successful!", type: .success)
                    let user = UserDetails(username: response.data?.username ?? "",
                                           isVerified: response.data?.isVerified ?? Bool(),
                                           phoneNumber: response.data?.phoneNumber ?? "",
                                           lastName: response.data?.lastName ?? "",
                                           id: response.data?.id ?? "",
                                           passwordHash: response.data?.passwordHash ?? "",
                                           firstName: response.data?.firstName ?? "",
                                           email: response.data?.email ?? "")
                    
                    DatabaseManager.shared.insertUser(user: user)
                    
                    clearAllFields([$firstName,$lastName,$username,$email,$phoneNumber,$password,$confirmPassword])
                    authManager.saveUserDetails(user)
                    authManager.isLoggedIn = true
                    navigateToListView = true
                } else {
                    toastManager.show(message: "Registration Failed : \(response.message)" , type: .warning)
                }
                
            case .failure(let error):
                print("Registration failed: \(error.localizedDescription)")
                isLoading = false
                toastManager.show(message: "Login failed: \(error.localizedDescription)", type: .error)
            }
        }
    }
}


struct CustomButton: View {
    var title: String
    var customColor: Color = .red
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(customColor)
                .cornerRadius(15.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RegistrationForm: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var username: String
    @Binding var email: String
    @Binding var phoneNumber: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "First Name", text: $firstName)
            CustomTextField(placeholder: "Last Name", text: $lastName)
            CustomTextField(placeholder: "Username", text: $username)
            CustomTextField(placeholder: "Email", text: $email)
            CustomTextField(placeholder: "Mobile Number", text: $phoneNumber)
            CustomTextField(placeholder: "Password", text: $password, isSecure: true)
            CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(15.0)
    }
}

#Preview {
    RegistrationView()
}
