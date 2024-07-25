//
//  ItemsView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 18/07/24.
//

import SwiftUI

struct ItemsView: View {
    var listObj : ListData
    @State private var itemsList: [ItemListData] = []
    @State private var selectedItem: ItemListData?
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false
    @State private var isCreatingNewList: Bool = false
    @StateObject var toastManager = ToastManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
//                    Button  {
//                        self.presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Image("backIcon")
//                            .resizable()
//                            .scaledToFit()
//                            .edgesIgnoringSafeArea(.all)
//                            .clipped()
//                            .frame(width: 40,height: 40)
//                    }
//                    .padding()
//                    .buttonStyle(PlainButtonStyle())
//
//                    Spacer()
                    
                    Text("")
                        .typingEffect(text: listObj.listName, speed: 0.1)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .padding()
                        .frame(alignment: .center)
                    
//                    Spacer()
                }
                .padding()
                
                HStack{
                    Spacer()
                        .frame(width: geo.size.width - 150)
                    
                    Button(action: {
                        isCreatingNewList = true
                    }) {
                        Text("Create Item")
                            .fontWeight(.bold)
                            .padding(7)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if itemsList.isEmpty {
                    Text("Oops You don't have any created items. \nPlease Create Items")
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(itemsList) { item in
                            ItemListView(item: item, editAction: {
                                selectedItem = item
                            }, deleteAction: {
                                deleteItem(item: item)
                            })
                        }
                        .padding(.all,5)
                    }
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.3), radius: 10.0)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .sheet(isPresented: $isCreatingNewList) {
                CreateItemsListView(listObj: listObj) { newItem in
                    createItemList(input: newItem)
                    isCreatingNewList = false
                }
                .frame(width: 500, height: 300)
            }
            .sheet(item: $selectedItem) { selectedItem in
                EditItemsListSheetView(item: itemsList[itemsList.firstIndex(where: { $0.id == selectedItem.id })!]) { updatedItem in
                    updateItemList(input: updatedItem)
                }
                .frame(width: 500, height: 300)
            }
            .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
        }
        .navigationTitle("Items List")
        .onAppear {
            let input = GetItemsListInput(listId: listObj.id)
            getAllItemsByListID(input: input)
        }
    }
    
    private func deleteItem(item: ItemListData) {
        deleteItemList(input: DeleteItemListInput(id: item.id ?? ""))
        selectedItem = nil // Reset selected item after deletion
    }
    
    private func getAllItemsByListID(input: GetItemsListInput){
        isLoading = true
        
        let getListByUserIDUrl = URL(string: "http://127.0.0.1:8080/itemslist/getitemsforlistId")!
        ApiManager.shared.post(url: getListByUserIDUrl, body: input) { (result: Result<GetItemlistById, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    if let data = response.data {
                        self.itemsList = data.map { ItemListData(itemName: $0.itemName, listID: $0.listID, quantity: $0.quantity, id: $0.id) }
                    }
                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    
    private func createItemList(input: CreateItemListInput){
        isLoading = true
        
        let createListUrl = URL(string: "http://127.0.0.1:8080/itemslist/itemslistcreate")!
        ApiManager.shared.post(url: createListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllItemsByListID(input: GetItemsListInput(listId: listObj.id))
                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func updateItemList(input: UpdateItemListInput){
        isLoading = true
        
        let updateListUrl = URL(string: "http://127.0.0.1:8080/itemslist/itemslistupdate")!
        ApiManager.shared.patch(url: updateListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllItemsByListID(input: GetItemsListInput(listId: listObj.id))
                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func deleteItemList(input: DeleteItemListInput){
        isLoading = true
        
        let deleteListUrl = URL(string: "http://127.0.0.1:8080/itemslist/itemslistdelete")!
        ApiManager.shared.delete(url: deleteListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllItemsByListID(input: GetItemsListInput(listId: listObj.id ))
                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
}

struct ItemListView: View {
    let item: ItemListData
    var editAction: () -> Void
    var deleteAction: () -> Void
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.itemName ?? "")
                    .font(.headline)
                Text("Quantity: \(item.quantity ?? "")")
                    .font(.subheadline)
            }
                
            Spacer()
            ItemsListActionButtonsView(editAction: editAction, deleteAction: deleteAction)
        }
        .padding(.vertical, 8)
    }
}

struct ItemsListActionButtonsView: View {
    var editAction: () -> Void // Closure for edit action
    var deleteAction: () -> Void // Closure for delete action
    
    var body: some View {
        HStack {
            Button(action: {
                editAction() // Call the edit action closure
            }) {
                Image(systemName: "pencil")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.all, 5)
            .background(Color.green)
            .cornerRadius(5)
            
            Button(action: {
                deleteAction() // Call the delete action closure
            }) {
                Image(systemName: "trash")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.all, 4)
            .background(Color.red)
            .cornerRadius(5)
        }
    }
}

#Preview {
    ItemsView(listObj: ListData(listName: "", userID: "", id: ""))
}
