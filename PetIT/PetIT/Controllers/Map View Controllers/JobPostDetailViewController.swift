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
    
    public var userModel: UserModel!
    public var jobPosts: JobPost!
    public var displayName: String?
    public var jobDescrip: String?
    
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserImageAndUsername()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    
    private func updateUI() {
        petImage.kf.setImage(with: URL(string: userModel.petPhotoURL ?? "No pet image found"))
        jobDescription.text = jobPosts.jobDescription
        petBio.text = userModel.petBio
        jobTimeFrame.text = jobPosts.timeFrame
        jobWages.text = String(jobPosts.wage)
}
    
    private func updateUserImageAndUsername() {
        DBService.fetchUser(userId: jobPosts.ownerId) { [weak self] (error, user) in
            if let error = error {
                self?.showAlert(title: "Error getting username", message: error.localizedDescription)
            } else if let user = user {
                self?.fullnameLabel.text = user.firstName
                self?.usernameLable.text = "@" + (user.displayName)
            }
            guard let photoURL = self?.userModel?.photoURL, !photoURL.isEmpty else {
                return
            }
            self?.petOwnerProfileImage.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "create_new"))
        }
    }
    
    @IBAction func bookJobButtonPressed(_ sender: UIButton) {
    }
    
}
