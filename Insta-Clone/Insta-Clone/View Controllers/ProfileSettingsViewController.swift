//
//  ProfileSettingsViewController.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class ProfileSettingsViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var upateProfileButton: UIBarButtonItem!
    @IBOutlet weak var displayNameField: UITextField!
    
    private let storageService = StorageService()
    
    private var selectedImage: UIImage? {
        didSet {
            profileImageView.image = selectedImage
        }
    }
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDisplayName()
        setupProfileImage()
    }
    
    private func setupProfileImage() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        guard let profilePicURL = user.photoURL else {
            profileImageView.image = UIImage(systemName: "person.fill")
            return
        }
        profileImageView.kf.setImage(with: profilePicURL)
    }
    
    private func setupDisplayName() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        guard let displayName = user.displayName else {
            displayNameField.placeholder = "Enter Display Name Here"
            return
        }
        displayNameField.placeholder = displayName
    }
    
    private func setupUI() {
        profileImageView.layer.cornerRadius = 4
        displayNameField.delegate = self
        displayNameField.isUserInteractionEnabled = false
    }
    
    @IBAction func changeProfilePhotoButtonPressed(_ sender: UIButton) {
         let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
         let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
             self.imagePickerController.sourceType = .camera
             self.present(self.imagePickerController, animated: true)
         }
         let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
             self.imagePickerController.sourceType = .photoLibrary
             self.present(self.imagePickerController, animated: true)
         }
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
             self.imagePickerController.sourceType = .camera
             self.present(self.imagePickerController, animated: true)
         }
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
         }
         alertController.addAction(photoLibraryAction)
         alertController.addAction(cancelAction)
         present(alertController, animated: true)
     }
    @IBAction func editDisplayNameButtonPressed(_ sender: UIButton) {
        displayNameField.isUserInteractionEnabled = true
        displayNameField.placeholder = ""
    }
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        UIViewController.showViewController(storyboardName: "LoginView", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error logging out", message: "\(error.localizedDescription)")
            }
        }
    }
    @IBAction func updateProfileButtonPressed(_ sender: UIBarButtonItem) {
        guard let displayName = displayNameField.placeholder,
            !displayName.isEmpty,
            let selectedImage = selectedImage else {
                showAlert(title: "Something is missing", message: "Please make sure both a display name, and profile photo are selected to update your profile")
                return
        }
        guard let user = Auth.auth().currentUser else { return }
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
        storageService.uploadPhoto(userId: user.uid, image: selectedImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "There was an error saving your profile", message: "Please try again later (error: \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile successfully updated!", message: "Display name: \(request?.displayName ?? "N/A")")
                        }
                    }
                })
            }
        }
    }
}
extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
            !text.isEmpty else {
                print("ERrrrr")
            return true
        }
        print("yay")
        textField.placeholder = text
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        return true
    }
}
extension ProfileSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
