//
//  PostingDetailViewController.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import Firebase

class JobPostDetailViewController: UIViewController {

    
    @IBOutlet weak var petOwnerProfileImage: CircularImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var petBio: UITextView!
    @IBOutlet weak var jobTimeFrame: UITextField!
    @IBOutlet weak var jobWages: UITextField!
    @IBOutlet weak var bookJobButton: UIButton!
    
    public var userModel: UserModel? {
        didSet {
            DispatchQueue.main.async {
                 self.updateUI()
            }
        }
    }
    public var jobPost: JobPost!
    public var displayName: String?
    public var jobDescrip: String?
    
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserImageAndUsername()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUserImageAndUsername()
    }
    
    
    private func updateUI() {
        if let photoURL = self.userModel?.photoURL, !photoURL.isEmpty {
            petOwnerProfileImage.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "create_new"))
        }
        petImage.kf.setImage(with: URL(string: jobPost.imageURLString), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        
        jobDescription.text = jobPost.jobDescription
        petBio.text = jobPost.petBio
        jobTimeFrame.text = jobPost.timeFrame
        jobWages.text = jobPost.wage
        fullnameLabel.text = userModel!.firstName
        usernameLable.text = "@" + (userModel!.displayName)
}
    
    private func updateUserImageAndUsername() {
        DBService.fetchUser(userId: jobPost.ownerId) { [weak self] (error, user) in
            if let error = error {
                self?.showAlert(title: "Error getting username", message: error.localizedDescription)
            } else if let user = user {
                self?.userModel = user
            }
        }
    }
    
    @IBAction func bookJobButtonPressed(_ sender: UIButton) {
        sender.setTitle("Task Accepted", for: .normal)
        showAlert(title: "Job Booked", message: "Thank You for booking with us!")
    }
    
}
