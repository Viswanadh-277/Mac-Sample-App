//
//  EditItemsListSheetView.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 21/07/24.
//

import SwiftUI

struct EditItemsListSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var item: ItemListData
    var action: (UpdateItemListInput) -> Void
    @StateObject var toastManager = ToastManager()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Item Name",
                                    text: Binding(
                                        get: { item.itemName ?? "" },
                                        set: { item.itemName = $0 }
                                    )
                    )
                    CustomTextField(
                        placeholder: "Quantity",
                        text: Binding(
                            get: { item.quantity ?? "" },
                            set: { item.quantity = $0 }
                        )
                    )
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(15)
                
                Button(action: {
                    if validateFields() {
                        let newItem = UpdateItemListInput(itemName: item.itemName ?? "" , quantity: item.quantity ?? "", id: item.id ?? "")
                        action(newItem)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        toastManager.show(message: toastManager.message, type: .error)
                    }
                }) {
                    Text("Update")
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
            .onAppear {
                item.itemName = item.itemName
            }
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func validateFields() -> Bool {
        if item.itemName == nil || item.itemName == "" {
            toastManager.show(message: "Item Name required.", type: .error)
            return false
        } else if item.quantity == nil || item.quantity == "" {
            toastManager.show(message: "Quantity required.", type: .error)
            return false
        }
        
        return true
    }
}

#Preview {
    EditItemsListSheetView(item: ItemListData(itemName: "", listID: "", quantity: "", id: "")) { _ in
        print("Item Updated")
    }
}
