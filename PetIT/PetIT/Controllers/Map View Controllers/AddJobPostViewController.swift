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

class AddJobPostViewController: UIViewController {

    @IBOutlet weak var petImage: RoundedButton!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var petBio: UITextView!
    @IBOutlet weak var timeFrame: UITextField!
    @IBOutlet weak var wages: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func petImageButtonPressed(_ sender: RoundedButton) {
    }

}
