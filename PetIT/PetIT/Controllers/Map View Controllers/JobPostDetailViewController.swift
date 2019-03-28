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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func bookJobButtonPressed(_ sender: UIButton) {
    }
    
}
