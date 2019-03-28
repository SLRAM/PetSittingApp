//
//  AddJobPostViewController.swift
//  PetIT
//
//  Created by Manny Yusuf on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import Kingfisher
import Toucan
import CoreLocation
import MapKit

class AddJobPostViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var petImage: RoundedButton!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var petBio: UITextView!
    @IBOutlet weak var timeFrame: UITextField!
    @IBOutlet weak var wages: UITextField!
    
    private var userLocation = CLLocationCoordinate2D()
    
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage?
    private var authservice = AppDelegate.authservice
    override func viewDidLoad() {
        super.viewDidLoad()
        jobDescription.clipsToBounds = true
        jobDescription.layer.cornerRadius = 10.0
        petBio.clipsToBounds = true
        petBio.layer.cornerRadius = 10.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Edit Location" {
            guard let mapDVC = segue.destination as? AddLocationViewController else {
                fatalError("cannot segue to bioDVC")
                
            }
//            bioDVC.userBio = userBio
        }
    }
    
    @IBAction func unwindFromEditLocation(segue: UIStoryboardSegue) {
        let mapVC = segue.source as! AddLocationViewController
        userLocation = mapVC.center
        print("users location is")
        print(userLocation)
        locationButton.setTitle("Location Added", for: .normal)
    }
 
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        let userLat = userLocation.latitude
        let userLong = userLocation.longitude
        if locationButton.titleLabel?.text != "Location Added" {
            let alertController = UIAlertController(title: "Unable to post. Choose a location.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return}
        guard let postDescription = jobDescription.text,
            !postDescription.isEmpty,
            let petDescription = petBio.text,
            !petDescription.isEmpty,
            let jobWage = wages.text,
            !jobWage.isEmpty,
            let jobTimeFrame = timeFrame.text,
            !jobTimeFrame.isEmpty,
            let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
                let alertController = UIAlertController(title: "Unable to post. Please fill in the required fields.", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true)
                return}
        guard let user = authservice.getCurrentUser() else {
            let alertController = UIAlertController(title: "Unable to post. Please login to post.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return}
        let docRef = DBService.firestoreDB
            .collection(JobPostCollectionKeys.CollectionKey)
            .document()
        StorageService.postImage(imageData: imageData, imageName: Constants.PetImagePath + "\(user.uid)/\(docRef.documentID)") { [weak self] (error, imageURL) in
            if let error = error {
                print("failed to post image with error: \(error.localizedDescription)")
            } else if let imageURL = imageURL {
                print("image posted and recieved imageURL - post blog to database: \(imageURL)")
                let jobPost = JobPost(createdDate: Date.getISOTimestamp(),
                                      postId: docRef.documentID,
                                      ownerId: user.uid,
                                      sitterId: nil,
                                      imageURLString: imageURL.absoluteString,
                                      jobDescription: postDescription,
                                      timeFrame: jobTimeFrame,
                                      wage: jobWage,
                                      petBio: petDescription,
                                      lat: userLat,
                                      long: userLong)
                DBService.postJob(jobPost: jobPost, completion: { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Posting Job Error", message: error.localizedDescription)
                    } else {
                        self?.showAlert(title: "Job Posted", message: "This Job will be added to your Job feed.") { action in
                            self?.dismiss(animated: true)
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func petImageButtonPressed(_ sender: RoundedButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [unowned self] (action) in

            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] (action) in

            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        present(alertController, animated: true)
        
    }

}
extension AddJobPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Blog text..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            if textView.text == "" {
                textView.text = "Blog text..."
                textView.textColor = .gray
            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension AddJobPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
        selectedImage = resizedImage.image
        petImage.setImage(resizedImage.image, for: .normal)
        dismiss(animated: true)
    }
}
