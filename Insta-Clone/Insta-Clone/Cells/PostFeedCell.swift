//
//  PostFeedCell.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher

class PostFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    
    public func configureCell(_ post: Post) {
        postImageView.kf.setImage(with: URL(string: post.imageURL))
        postCaptionLabel.text = ("\(post.caption)")
        createdByLabel.text = ("@\(post.createdBy)")
    }
}
