//
//  ProfileHeaderView.swift
//  PetIT
//
//  Created by Manny Yusuf on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func willSignOut(profileHeaderView: ProfileHeaderView)
    func willEditProfile(profileHeaderView: ProfileHeaderView)
}

class ProfileHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ProfilebioTextField: UITextField!
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        delegate?.willEditProfile(profileHeaderView: self)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        delegate?.willSignOut(profileHeaderView: self)
    }
}
