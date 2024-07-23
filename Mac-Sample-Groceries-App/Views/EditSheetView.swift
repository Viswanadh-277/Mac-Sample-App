//
//  EditSheetView.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 21/07/24.
//

import SwiftUI

struct EditSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var item: ListData
    var action: (UpdateListInput) -> Void
    @StateObject var toastManager = ToastManager()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                CustomTextField(placeholder: "List Name", text: $item.listName)
                    .padding()
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(15)
                
                Button(action: {
                    if validateFields() {
                        let newItem = UpdateListInput(listName: item.listName, id: item.id)
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
                item.listName = item.listName
            }
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func validateFields() -> Bool {
        if item.listName.isEmpty {
            toastManager.show(message: "List Name required.", type: .error)
            return false
        }
        
        return true
    }
}


#Preview {
    EditSheetView(item: ListData(listName: "", userID: "", id: "")) { _ in
        print("List edited")
    }
}
