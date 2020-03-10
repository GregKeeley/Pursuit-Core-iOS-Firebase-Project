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
    static let itemsCollection = "items"
    private let db = Firestore.firestore()
    public func createItem(itemName: String, price: Double, category: Category, displayName: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseService.itemsCollection).document()
        // Create post here to upload to database
        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData([:]) {
            (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
            
        }
    }
    
}
