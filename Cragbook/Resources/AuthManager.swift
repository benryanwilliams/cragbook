//
//  AuthManager.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import FirebaseAuth

public class AuthManager {
    
    // Allow this instance of AuthManager to be accessed from other files
    static let shared = AuthManager()
    
    // MARK:- Public
    
    // Non-escaping closure (default) : A closure that’s called within the function it was passed into, i.e. before it returns.
    
    // Escaping Closure (below) : An escaping closure is a closure that’s called after the function it was passed to returns. In other words, it outlives the function it was passed to. In the example below, we are using 'completion' in a separate closure, so in order for 'completion' to be used after 'return' we have to mark the closure as escaping.
    
    // When this method is called from LoginViewController, as per if the usernameEmailField has an '@' and a '.' then the email value is populated, if not then the username value is populated. This is why they are optional strings here. See also 'Login Functionality' in LoginViewController
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        // If email is not nil then assign usernameEmailField to email, else assign to username below
        if let email = email {
            // Email login
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
        else if let username = username {
            // TODO: Username login
            print(username)
        }
        
        
        
    }
    
    public func registerNewUser(username: String, email: String, password: String) {
        /*
         - Check if username is available
         - Check if email is available
         - Create account
         - Insert account to database
         */
        
    }
    
}

