//
//  EditOwnerProfileTableViewController.swift
//  PetIT
//
//  Created by Manny Yusuf on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import Toucan
import Kingfisher

class EditOwnerProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userBio: UITextField!
    
    public var owner: UserModel!
    private var selectedImage: UIImage?
    
     private var authservice = AppDelegate.authservice
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformTextFieldDelegates()
        updateUI()
    }
    
    private func conformTextFieldDelegates() {
        firstName.delegate = self
        lastName.delegate = self
        username.delegate = self
        userBio.delegate = self
    }
    
    private func updateUI() {
        if let imageURLString = owner.photoURL {
            profileImage.kf.setImage(with: URL(string: imageURLString), for: .normal, placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        }
        firstName.text = owner.firstName
        lastName.text = owner.lastName
        username.text = owner.displayName
        userBio.text = owner.bio
    }
    
    @IBAction func profileImageButtonPressed(_ sender: CircularButton) {
        setupAndPresentPickerController()
    }
    private func setupAndPresentPickerController() {
        var actionTitles = [String]()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionTitles = ["Photo Library", "Camera"]
        } else {
            actionTitles = ["Photo Library"]
        }
        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
            }, { cameraAction in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            }
            ])
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
            let user = authservice.getCurrentUser(),
            let displayName = username.text, !displayName.isEmpty,
            let firstName = firstName.text, let lastName = lastName.text, let userBio = userBio.text else {
                showAlert(title: "Missing Fields", message: "A photo and username are Required")
                return
        }
        
        StorageService.postImage(imageData: imageData, imageName: Constants.ProfileImagePath + user.uid) { [weak self] (error, imageURL) in
            if let error = error {
                self?.showAlert(title: "Error Saving Photo", message: error.localizedDescription)
            } else if let imageURL = imageURL {
                let request = user.createProfileChangeRequest()
                request.displayName = displayName
                request.photoURL = imageURL
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                    }
                })
                
                DBService.firestoreDB
                    .collection(UsersCollectionKeys.CollectionKey)
                    .document(user.uid)
                    .updateData([UsersCollectionKeys.PhotoURLKey : imageURL.absoluteString,
                                 UsersCollectionKeys.DisplayNameKey : displayName,
                                 UsersCollectionKeys.FirstNameKey : firstName,
                                 UsersCollectionKeys.LastNameKey : lastName,
                                 UsersCollectionKeys.BioKey : userBio
                                 ], completion: { (error) in
                        if let error = error {
                            self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                        }
                    })
                self?.dismiss(animated: true)
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    

}



extension EditOwnerProfileTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditOwnerProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image not available")
            return
        }
        let size = CGSize(width: 500, height: 500)
        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
        selectedImage = resizedImage
        profileImage.setImage(resizedImage, for: .normal)
        dismiss(animated: true)
    }
}
