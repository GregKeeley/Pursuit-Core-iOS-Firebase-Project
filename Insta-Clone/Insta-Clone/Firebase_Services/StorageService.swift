//
//  StorageService.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    private let storageRef = Storage.storage().reference()
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        var photoReference: StorageReference!
        if let userId = userId {
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId {
            photoReference = storageRef.child("ItemPhotos/\(itemId).jpg")
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let _ = photoReference.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
}
