//
//  DatabaseService.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    static let postsCollection = "posts"
    private let db = Firestore.firestore()
    public func createPost(postCaption: String, displayName: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseService.postsCollection).document()
        // Create post here to upload to database
        db.collection(DatabaseService.postsCollection).document(documentRef.documentID).setData(["createdBy": displayName, "caption": postCaption, "postedDate": Timestamp(date: Date()), "postID": documentRef.documentID, "userID": user.uid]) {
            (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
            
        }
    }
    
}
