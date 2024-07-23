//
//  CustomTextField.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 20/07/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundColor(text.isEmpty ? Color(.placeholderTextColor) : .primary)
                .background(Color(NSColor.windowBackgroundColor))
                .offset(y: text.isEmpty ? 0 : -28)
                .scaleEffect(text.isEmpty ? 1 : 0.9, anchor: .leading)
            
            if isSecure {
                SecureField("", text: $text)
                    .textFieldStyle(.plain)
            } else {
                TextField("", text: $text)
                    .textFieldStyle(.plain)
            }
        }
        .animation(.easeOut, value: !text.isEmpty)
        .padding(.horizontal)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(text.isEmpty ? .black.opacity(0.1) : .primary , lineWidth: text.isEmpty ? 2 : 1)
                .frame(height: 50)
        )
    }
}
