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
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy, h:mm a"
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseService.postsCollection).document()
        db.collection(DatabaseService.postsCollection).document(documentRef.documentID).setData(["createdBy": displayName, "caption": postCaption, "postedDate": Timestamp(date: Date()), "postID": documentRef.documentID, "userID": user.uid]) {
            (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                print(Timestamp(date: Date()))
                completion(.success(documentRef.documentID))
            }
            
        }
    }
    
}
