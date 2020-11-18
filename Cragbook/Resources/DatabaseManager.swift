//
//  DatabaseManager.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import FirebaseFirestore

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    // MARK:- Public
    
    // This below (///) makes it a docstring, which makes the description appear when you call the method
    /// Check if username and email are available
    /// -   Parameters
    /// -       username: String representing username
    /// -       email: String representing email
    public func canCreateUser(email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Insert new user data to database
    /// -   Parameters
    /// -       username: String representing username
    /// -       email: String representing email
    /// -       completion: Async callback for result if database entry succeeded
    public func insertNewUser(email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.collection(email).addDocument(data: ["Username":username]) {error in
            if error == nil {
                // Success
                completion(true)
                return
            }
            else {
                // Failed
                completion(false)
                return
            }
        }
        
    }
}



