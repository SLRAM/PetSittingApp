//
//  PostCell.swift
//  PetIT
//
//  Created by Manny Yusuf on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var jobDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
