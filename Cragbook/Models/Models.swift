//
//  Models.swift
//  Cragbook
//
//  Created by Ben Williams on 24/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import Foundation

enum Gender {
    case male, female, other
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType {
    case photo, video
}
/// Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImageURL: URL
    let postURL: URL
    let caption: String?
    let likes: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
}

/// Represents a like on a post
struct PostLike {
    let postIdentifier: String
    let username: String
}

/// Represents a like on a comment
struct CommentLike {
    let commentIdentifier: String
    let username: String
}

/// Represents a comment on a post
struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
