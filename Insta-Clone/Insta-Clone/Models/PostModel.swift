//
//  PostModel.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/11/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation


struct Post {
    let imageURL: String
    let createdBy: String
    let caption: String
    let postID: String
    let postedDate: Date
}
extension Post {
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "No Image URL"
        self.createdBy = dictionary["createdBy"] as? String ?? "No User name"
        self.caption = dictionary["caption"] as? String ?? "No Caption"
        self.postID = dictionary["postID"] as? String ?? "No post ID"
        self.postedDate = dictionary["postedDate"] as? Date ?? Date()
    }
}
