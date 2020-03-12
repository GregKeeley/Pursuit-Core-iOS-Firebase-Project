//
//  PostDetailViewController.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/12/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var createByLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.timeZone = .current
        return formatter
    }()
    
    init?(coder: NSCoder, post: Post) {
        self.post = post
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(for: post ?? Post(imageURL: "N/A", createdBy: "N/A", caption: "N/A", postID: "N/A", postedDate: Date(), userID: "N/A"))
    }
    private func setupUI(for post: Post) {
        postDate.text = dateFormatter.string(from: post.postedDate)
        createByLabel.text = post.createdBy
        captionLabel.text = post.caption
        postImageView.kf.setImage(with: URL(string: post.imageURL))
    }
}
