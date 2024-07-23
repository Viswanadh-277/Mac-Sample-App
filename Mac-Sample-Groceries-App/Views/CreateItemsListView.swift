//
//  CreateItemsListView.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 21/07/24.
//

import SwiftUI

struct CreateItemsListView: View {
    var listObj : ListData
    @State private var newName: String = ""
    @State private var newQuantity: String = ""
    var action: (CreateItemListInput) -> Void
    @StateObject var toastManager = ToastManager()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(spacing :20) {
                    CustomTextField(placeholder: "Item Name", text: $newName)
                    CustomTextField(placeholder: "Quantity", text: $newQuantity)
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(15)
                
            
                
                Button(action: {
                    if validateFields() {
                        let newItem = CreateItemListInput(itemName: newName, quantity: newQuantity, listID: listObj.id)
                        action(newItem)
                    } else {
                        toastManager.show(message: toastManager.message, type: .error)
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
            toastManager.show(message: "Item Name required.", type: .error)
            return false
        }
        
        return true
    }
}

#Preview {
    CreateItemsListView(listObj: ListData(listName: "", userID: "", id: "")){ _ in
        print("Created new item")
    }
}
