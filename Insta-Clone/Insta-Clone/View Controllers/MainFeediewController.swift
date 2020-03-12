//
//  ViewController.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MainFeediewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                dump(self.posts)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.postsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                print("There are \(snapshot.documents.count) posts")
                let posts = snapshot.documents.map { Post($0.data()) }
                let sortedPosts = posts.sorted { $0.postedDate > $1.postedDate }
                self?.posts = sortedPosts
            }
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    
}


extension MainFeediewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostFeedCell else {
            fatalError("Failed to dequeue PostFeedCell")
        }
        let post = posts[indexPath.row]
        cell.configureCell(post)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.cornerRadius = 4
        return cell
    }
}
extension MainFeediewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        let maxWidth = width * 0.95
        return CGSize(width: maxWidth, height: maxWidth)
    }
}
