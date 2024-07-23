//
//  ToastView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 19/07/24.
//

import SwiftUI

enum ToastType {
    case success, error, warning
    
    var color: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        case .warning: return Color.orange
        }
    }
}

struct ToastView: View {
    var message: String = ""
    let type: ToastType
    
    var body: some View {
        Text(message)
            .padding()
            .background(type.color)//Color.black.opacity(0.5) //Color(NSColor.windowBackgroundColor)
            .foregroundColor(.primary)
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.slide)
            .animation(.easeInOut(duration: 0.5),value: message)
            
    }
}


extension View {
    func toast(message: String, isShowing: Binding<Bool>, type: ToastType) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                VStack {
                    Spacer()
                    ToastView(message: message, type: type)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5), value: isShowing.wrappedValue)
            }
        }
    }
}

class ToastManager: ObservableObject {
    
    @Published var isShowing: Bool = false
    @Published var message: String = ""
    @Published var toastType: ToastType = .error
    
    func show(message: String, type: ToastType) {
//        DispatchQueue.main.async {
            self.message = message
            self.toastType = type
            withAnimation {
                self.isShowing = true
            }
//        }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}

