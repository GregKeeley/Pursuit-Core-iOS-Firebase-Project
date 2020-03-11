//
//  CreatePostViewController.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private var selectedImage: UIImage? {
        didSet {
            postImageView.image = selectedImage
        }
    }
    private lazy var tapGesture: UIGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(selectImage(_:)))
        return gesture
    }()
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.layer.cornerRadius = 4
        //        uploadButton.isEnabled = false
    }
    @objc private func selectImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    @IBAction func uploadPost(_ sender: UIButton) {
        guard let caption = captionTextField.text,
            !caption.isEmpty,
            let selectedImage = selectedImage else {
                showAlert(title: "Something is missing", message: "Please make sure you have selected a photo, and set a caption")
                return
        }
        guard let userName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete profile", message: "Please go to settings to complete your profile")
            return
        }
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: postImageView.bounds)
        dbService.createPost(postCaption: caption, displayName: userName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error creating post", message: "something went wrong: \(error.localizedDescription)")
                }
            case .success(let documentID):
                self?.upload(photo: resizedImage, documentID: documentID)
            }
        }
    }
    private func upload(photo: UIImage, documentID: String) {
        storageService.uploadPhoto(itemId: documentID, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateImageItemURL(url, documentId: documentID)
            }
        }
    }
    private func updateImageItemURL(_ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.postsCollection).document(documentId).updateData(["imageURL" : url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to update post", message: "\(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    print("yerp")
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}
extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain image")
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
extension CreatePostViewController: UITextFieldDelegate {
    
}
