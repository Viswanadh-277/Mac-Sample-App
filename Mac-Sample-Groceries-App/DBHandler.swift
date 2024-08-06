//
//  DBHandler.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 29/07/24.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    
    private init() {
        deleteDatabase()
        setupDatabase()
    }
    func deleteDatabase() {
        do {
            // Get the path for the database file
            let documentDirectory = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let dbPath = documentDirectory.appendingPathComponent("mydatabase.sqlite3").path
            print("Database Path: \(dbPath)")
            
            // Check if the file exists
            if FileManager.default.fileExists(atPath: dbPath) {
                // Delete the file
                try FileManager.default.removeItem(atPath: dbPath)
                print("Database file deleted successfully.")
            } else {
                print("Database file does not exist.")
            }
        } catch {
            print("Error deleting database file: \(error)")
        }
    }
    
    private func setupDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let dbPath = documentDirectory.appendingPathComponent("mydatabase.sqlite3").path
            print("Database Path: \(dbPath)")
            
            // Initialize the database connection
            db = try Connection(dbPath)
            
            // Enable foreign key constraints
//            try db?.execute("PRAGMA foreign_keys = ON;")
            db?.foreignKeys = true
            
            // Verify if foreign keys are enabled
            let isForeignKeysEnabled = try db?.scalar("PRAGMA foreign_keys") as? Int
            print("Foreign keys enabled: \(isForeignKeysEnabled == 1)")
            
            // Create tables
            createUserTable()
            createListsTable()
            createItemsTable()
            
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    func deleteAllTables() {
            do {
                try db?.run("DROP TABLE IF EXISTS lists")
                try db?.run("DROP TABLE IF EXISTS items")
                try db?.run("DROP TABLE IF EXISTS users")
            } catch {
                print("Error dropping tables: \(error)")
            }
        }
    
    
    // MARK: - Table Creation
     func createUserTable() {
        do {
            let users = Table("users")
            let id = Expression<String>("id")
            let username = Expression<String>("username")
            let firstName = Expression<String>("firstName")
            let lastName = Expression<String>("lastName")
            let email = Expression<String>("email")
            let phoneNumber = Expression<String>("phoneNumber")
            let passwordHash = Expression<String>("passwordHash")
            let isVerified = Expression<Bool>("isVerified")
            
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(username)
                t.column(firstName)
                t.column(lastName)
                t.column(email, unique: true)
                t.column(phoneNumber, unique: true)
                t.column(passwordHash)
                t.column(isVerified)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    func createListsTable() {
        do {
            let lists = Table("lists")
            let id = Expression<String>("id")
            let listName = Expression<String>("listName")
            let userID = Expression<String>("userID")
            
            try db?.run(lists.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(listName)
                t.column(userID)
                t.foreignKey(userID, references: Table("users"), Expression<String>("id"), delete: .cascade)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    func createItemsTable() {
        do {
            let items = Table("items")
            let itemID = Expression<String>("id")
            let itemName = Expression<String>("itemName")
            let listIDColumn = Expression<String>("listID")
            let quantity = Expression<String>("quantity")
            
            try db?.run(items.create(ifNotExists: true) { t in
                t.column(itemID, primaryKey: true)
                t.column(itemName)
                t.column(listIDColumn)
                t.column(quantity)
                t.foreignKey(listIDColumn, references: Table("lists"), Expression<String>("id"), delete: .cascade)
            })
            
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    // MARK: - Create
    func insertUser(user: UserDetails) {
        let users = Table("users")
        let id = Expression<String>("id")
        let username = Expression<String>("username")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let email = Expression<String>("email")
        let phoneNumber = Expression<String>("phoneNumber")
        let passwordHash = Expression<String>("passwordHash")
        let isVerified = Expression<Bool>("isVerified")
        
        let insert = users.insert(
                    id <- user.id ?? "",
                    username <- user.username ?? "",
                    firstName <- user.firstName ?? "",
                    lastName <- user.lastName ?? "",
                    email <- user.email ?? "",
                    phoneNumber <- user.phoneNumber ?? "",
                    passwordHash <- user.passwordHash ?? "",
                    isVerified <- user.isVerified ?? false
                )
        
        do {
            try db?.run(insert)
            print("User inserted successfully")
        } catch {
            print("Error inserting user: \(error)")
        }
    }
    
    func insertLists(_ lists: [ListData]) {
        do {
            let listsTable = Table("lists")
            let id = Expression<String>("id")
            let listName = Expression<String>("listName")
            let userID = Expression<String>("userID")
            
            for list in lists {
//                let insert = listsTable.insert(
//                    id <- list.id,
//                    listName <- list.listName,
//                    userID <- list.userID
//                )
                
                let insertOrReplace = listsTable.insert(or: .replace,
                                                        id <- list.id,
                                                        listName <- list.listName,
                                                        userID <- list.userID
                )
                try db?.run(insertOrReplace)
            }
        } catch {
            print("Error inserting list: \(error)")
        }
    }
    
    func insertItems(_ items: [ItemListData]) {
        do {
            let itemTable = Table("items")
            let id = Expression<String>("id")
            let itemName = Expression<String>("itemName")
            let listID = Expression<String>("listID")
            let quantity = Expression<String>("quantity")
            
            for item in items {
                let insertOrReplace = itemTable.insert(or: .replace,
                                                       id <- item.id,
                                                       itemName <- item.itemName,
                                                       listID <- item.listID,
                                                       quantity <- item.quantity
                )
                
                try db?.run(insertOrReplace)
            }
        } catch {
            print("Error inserting item: \(error)")
        }
    }
    
    // MARK: - Read
    func fetchUser() -> UserDetails? {
        let users = Table("users")
        let userID = Expression<String>("id")
        let username = Expression<String>("username")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let email = Expression<String>("email")
        let phoneNumber = Expression<String>("phoneNumber")
        let passwordHash = Expression<String>("passwordHash")
        let isVerified = Expression<Bool>("isVerified")
        
        if let userRow = try? db?.pluck(users) {
            return UserDetails(
                username: userRow[username], 
                isVerified: userRow[isVerified],
                phoneNumber: userRow[phoneNumber],
                lastName: userRow[lastName],
                id: userRow[userID],
                passwordHash: userRow[passwordHash], 
                firstName: userRow[firstName],
                email: userRow[email]
            )
        }
        return nil
    }
    
    func fetchAllUsers() -> [UserDetails] {
        let users = Table("users")
        let id = Expression<String>("id")
        let username = Expression<String>("username")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let email = Expression<String>("email")
        let phoneNumber = Expression<String>("phoneNumber")
        let passwordHash = Expression<String>("passwordHash")
        let isVerified = Expression<Bool>("isVerified")
        
        var userList = [UserDetails]()
        
        do {
            for userRow in try db!.prepare(users) {
                let user = UserDetails(
                    username: userRow[username], 
                    isVerified: userRow[isVerified],
                    phoneNumber: userRow[phoneNumber],
                    lastName: userRow[lastName],
                    id: userRow[id],
                    passwordHash: userRow[passwordHash], 
                    firstName: userRow[firstName],
                    email: userRow[email]
                )
                userList.append(user)
            }
        } catch {
            print("Error fetching users: \(error)")
        }
        
        return userList
    }
    
    func fetchLists(userID: String) -> [ListData] {
        var fetchedLists = [ListData]()
        do {
            let lists = Table("lists")
            let id = Expression<String>("id")
            let listName = Expression<String>("listName")
            let userIDColumn = Expression<String>("userID")
            
            guard let queryResults = try db?.prepare(lists.filter(userIDColumn == userID)) else {
                print("Database preparation error")
                return []
            }
            
            for list in queryResults {
                fetchedLists.append(ListData(
                    listName: list[listName],
                    userID: list[userIDColumn],
                    id: list[id]
                ))
            }
        } catch {
            print("Error fetching lists: \(error)")
        }
        return fetchedLists
    }
    
    func fetchItems(listID: String) -> [ItemListData] {
        var fetchedItems = [ItemListData]()
        do {
            let items = Table("items")
            let id = Expression<String>("id")
            let itemName = Expression<String>("itemName")
            let listIDColumn = Expression<String>("listID")
            let quantity = Expression<String>("quantity")
            
            guard let queryResults = try db?.prepare(items.filter(listIDColumn == listID)) else {
                print("Database preparation error")
                return []
            }
            
            for item in queryResults {
                fetchedItems.append(ItemListData(
                    itemName: item[itemName],
                    listID: item[listIDColumn],
                    quantity: item[quantity],
                    id: item[id]
                ))
            }
        } catch {
            print("Error fetching items: \(error)")
        }
        return fetchedItems
    }
    
    // MARK: - Update
    func updateUser(user: UserDetails) {
        let users = Table("users")
        let id = Expression<String>("id")
        let username = Expression<String>("username")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let email = Expression<String>("email")
        let phoneNumber = Expression<String>("phoneNumber")
        let passwordHash = Expression<String>("passwordHash")
        let isVerified = Expression<Bool>("isVerified")
        
        // Safely unwrap the user.id
        guard let userId = user.id else {
            print("User ID is nil")
            return
        }
        
        let userToUpdate = users.filter(id == userId)
        
        let update = userToUpdate.update(
            username <- user.username ?? "",
            firstName <- user.firstName ?? "",
            lastName <- user.lastName ?? "",
            email <- user.email ?? "",
            phoneNumber <- user.phoneNumber ?? "",
            passwordHash <- user.passwordHash ?? "",
            isVerified <- user.isVerified ?? false
        )
        
        do {
            try db?.run(update)
            print("User updated successfully")
        } catch {
            print("Error updating user: \(error)")
        }
    }
    
    
    func updateList(list: ListData) {
        do {
            let lists = Table("lists")
            let id = Expression<String>("id")
            let listName = Expression<String>("listName")
            let userID = Expression<String>("userID")
            
            let listToUpdate = lists.filter(id == list.id)
            try db?.run(listToUpdate.update(
                listName <- list.listName,
                userID <- list.userID
            ))
        } catch {
            print("Error updating list: \(error)")
        }
    }
    
    func updateItem(_ item: ItemListData) {
        do {
            let items = Table("items")
            let id = Expression<String>("id")
            let itemName = Expression<String>("itemName")
            let listID = Expression<String>("listID")
            let quantity = Expression<String>("quantity")
            
            let itemToUpdate = items.filter(id == item.id)
            try db?.run(itemToUpdate.update(
                itemName <- item.itemName,
                listID <- item.listID,
                quantity <- item.quantity
            ))
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    // MARK: - Delete
    func deleteUser(byID id: String) {
        let users = Table("users")
        let userID = Expression<String>("id")
        
        let userToDelete = users.filter(userID == id)
        let delete = userToDelete.delete()
        
        do {
            try db?.run(delete)
            print("User deleted successfully")
        } catch {
            print("Error deleting user: \(error)")
        }
    }
    
    func deleteList(listID: String) {
        do {
            let lists = Table("lists")
            let id = Expression<String>("id")
            let listToDelete = lists.filter(id == listID)
            try db?.run(listToDelete.delete())
            
        } catch {
            print("Error deleting list: \(error)")
        }
    }
    
    func deleteItem(itemID: String) {
        do {
            let items = Table("items")
            let id = Expression<String>("id")
            
            let itemToDelete = items.filter(id == itemID)
            try db?.run(itemToDelete.delete())
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
