//
//  StorageManager.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import FirebaseStorage

public class StorageManager {
    
    // Allows StorageManager to be used without creating further instances
    static let shared = StorageManager()
    
    // Create bucket for storage
    private let bucket = Storage.storage().reference()
    
    // Add custom error message
    public enum StorageManagerError: Error {
        case failedToDownload
    }
    
    // MARK:- Public

    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }
    
    // Attempts to download image, passing in the reference, and on completion this produces an option URL and / or error
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, StorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { (url, error) in
            // If the URL is nil or there is an error, the error in the completion block is set to failedToDownload (definted in the enum above) and the function returns
            guard let url = url, error == nil else {
                completion(.failure(StorageManagerError.failedToDownload))
                return
            }
            // Else, if the URL is not nil and there is no error, the url is passed into the URL part of the completion block
            completion(.success(url))
        })
    }
    
    enum UserPostType {
        case photo, video
    }
    
    public struct UserPost {
        let postType: UserPostType
    }
    
    
    
}
