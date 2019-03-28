//
//  ProfileViewController.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import Firebase
import Toucan

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    private lazy var profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        return headerView
    }()
    
    private var authservice = AppDelegate.authservice
    
    private var owner: User?
    private var jobPosts = [JobPost]() {
        didSet {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileHeaderView.delegate = self
        configureTableView()
    }
    
    private func configureTableView() {
        
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = authservice.getCurrentUser() else {
            print("No logged user")
            return
        }
        DBService.getBlogger(userId: currentUser.uid) { [weak self] (error, blogger) in
            if let error = error {
                self?.showAlert(title: "Error fetching account info", message: error.localizedDescription)
            } else if let blogger = blogger {
                self?.user = blogger
            }
        }
    }

}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func willSignOut(profileHeaderView: ProfileHeaderView) {
        <#code#>
    }
    
    func willEditProfile(profileHeaderView: ProfileHeaderView) {
        <#code#>
    }
}
