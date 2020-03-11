//
//  ViewController.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class MainFeediewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }


}
extension MainFeediewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostFeedCell else {
            fatalError("Failed to dequeu PostFeedCell")
        }
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
