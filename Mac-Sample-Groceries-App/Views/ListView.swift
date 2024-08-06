//
//  ListView.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 18/07/24.
//

import SwiftUI

struct ListView: View {
    @StateObject private var authManager = AuthManager()
    @State var userObj: UserDetails
    @State private var lists: [ListData] = []
    @State private var selectedItem: ListData?
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false
    @State private var isCreatingNewList: Bool = false
    @State private var navigateToItemsView = false
    @State private var navigateToProfile = false
    @StateObject var toastManager = ToastManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Text("")
                            .typingEffect(text: "Welcome, \((userObj.firstName ?? "") + " " + (userObj.lastName ?? ""))!", speed: 0.1)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.monospaced)
                            .padding(.leading)
                        
                        Spacer()
                        
                        VStack (spacing: 20){
                            Button {
                                authManager.logout()
                                navigateToProfile = true
                            } label: {
                                Image("personIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                
                                Text("Profile")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing)
                            
                            Button(action: {
                                isCreatingNewList = true
                            }) {
                                Text("Create List")
                                    .fontWeight(.bold)
                                    .padding(7)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    
                    if isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if lists.isEmpty {
                        Text("Oops You don't have any created List. \nPlease Create List")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(lists) { item in
                                NavigationLink(destination: ItemsView(listObj: item)) {
                                    ListItemView(item: item, editAction: {
                                        selectedItem = item
                                    }, deleteAction: {
                                        deleteItem(item: item)
                                    })
                                }
                            }
                            .padding(.all, 5)
                        }
                        .cornerRadius(15)
                        .padding()
                        .shadow(color: colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.3), radius: 10.0)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .navigationDestination(isPresented: $navigateToProfile) {
                    ProfileInfoView(userObj: userObj)
                }
                .sheet(isPresented: $isCreatingNewList) {
                    CreateListView(userObj: userObj) { newItem in
                        createList(input: newItem)
                        isCreatingNewList = false
                    }
                    .frame(width: 500, height: 300)
                }
                .sheet(item: $selectedItem) { selectedItem in
                    EditSheetView(item: lists[lists.firstIndex(where: { $0.id == selectedItem.id })!]) { updatedItem in
                        updateList(input: updatedItem)
                    }
                    .frame(width: 500, height: 300)
                }
            }
            .navigationBarBackButtonHidden()
        }
        .toast(message: toastManager.message, isShowing: $toastManager.isShowing, type: toastManager.toastType)
        .navigationTitle("List Items")
        .onAppear {
            let input = GetListItemInput(userId: userObj.id ?? "")
            let fetchedLists = DatabaseManager.shared.fetchLists(userID: input.userId)
            if fetchedLists.isEmpty {
                getAllListItemsByUserID(input: input)
            } else {
                self.lists = fetchedLists
            }
        }
    }
    
    private func deleteItem(item: ListData) {
        deleteList(input: DeleteListInput(id: item.id))
        DatabaseManager.shared.deleteList(listID: item.id)
        
        // Reload the list
        let input = GetListItemInput(userId: userObj.id ?? "")
        self.lists = DatabaseManager.shared.fetchLists(userID: input.userId)
        
        selectedItem = nil // Reset selected item after deletion
    }
    
    private func getAllListItemsByUserID(input: GetListItemInput){
        isLoading = true
        
//        let getListByUserIDUrl = URL(string: "http://127.0.0.1:8080/createlist/getlistbyuserid")!
        let getListByUserIDUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.getlistbyuserid)!
        ApiManager.shared.post(url: getListByUserIDUrl, body: input) { (result: Result<Getlistbyuserid, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    if let data = response.data {
                        // Insert data into SQLite
                        let listData = data.map { ListData(listName: $0.listName, userID: $0.userID, id: $0.id) }
                        DatabaseManager.shared.insertLists(listData)
                        
                        self.lists = DatabaseManager.shared.fetchLists(userID: input.userId)
                    }
//                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    
    private func createList(input: CreateListInput){
        isLoading = true
        
//        let createListUrl = URL(string: "http://127.0.0.1:8080/createlist/listcreate")!
        let createListUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.listcreate)!
        ApiManager.shared.post(url: createListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllListItemsByUserID(input: GetListItemInput(userId: userObj.id ?? ""))
//                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func updateList(input: UpdateListInput){
        isLoading = true
        
//        let updateListUrl = URL(string: "http://127.0.0.1:8080/createlist/listupdate")!
        let updateListUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.listupdate)!
        ApiManager.shared.patch(url: updateListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllListItemsByUserID(input: GetListItemInput(userId: userObj.id ?? ""))
//                    toastManager.show(message: "\(response.message)", type: .success)
                } else {
                    toastManager.show(message: "\(response.message)", type: .warning)
                }
            case .failure(let error):
                isLoading = false
                toastManager.show(message: "\(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func deleteList(input: DeleteListInput){
        isLoading = true
        
        let deleteListUrl = URL(string: APIEndpoints.BASEURL + APIEndpoints.listdelete)!
//        let deleteListUrl = URL(string: "http://127.0.0.1:8080/createlist/listdelete")!
        ApiManager.shared.delete(url: deleteListUrl, body: input) { (result: Result<SuccessResponse, Error>) in
            switch result {
            case .success(let response):
                isLoading = false
                if response.status == 1 {
                    getAllListItemsByUserID(input: GetListItemInput(userId: userObj.id ?? ""))
//                    toastManager.show(message: "\(response.message)", type: .success)
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

struct ListItemView: View {
    let item: ListData
    var editAction: () -> Void
    var deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Text(item.listName)
                .font(.headline)
                
            Spacer()
            ActionButtonsView(editAction: editAction, deleteAction: deleteAction)
        }
        .padding(.vertical, 8)
    }
}

struct ActionButtonsView: View {
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
    ListView(userObj: UserDetails(username: "", isVerified: false, phoneNumber: "", lastName: "", id: "", passwordHash: "", firstName: "", email: ""))
}
