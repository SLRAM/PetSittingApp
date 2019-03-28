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
    
    private var owner: UserModel? {
        didSet {
            updateProfileUI(user: owner!)
            fetchOwnerPosts(user: owner!)
        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }
    
    private func configureTableView() {
        profileTableView.tableHeaderView = profileHeaderView
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = authservice.getCurrentUser() else {
            print("No logged user")
            return
        }
        DBService.fetchUser(userId: currentUser.uid) { [weak self] (error, owner) in
            if let error = error {
                self?.showAlert(title: "Error fetching account info", message: error.localizedDescription)
            } else if let owner = owner {
                self?.owner = owner
            }
        }
    }
    
    private func updateProfileUI(user: UserModel) {
        profileHeaderView.ProfilebioTextField.text = user.bio ?? ""
        profileHeaderView.fullnameLabel.text = user.fullName
        profileHeaderView.usernameLabel.text = "@" + (user.displayName)
        if let profileImageURL = user.photoURL {
            profileHeaderView.profileImage.kf.setImage(with: URL(string: profileImageURL), for: .normal, placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        }
    }
    
    private func fetchOwnerPosts(user: UserModel) {
        // https://firebase.google.com/docs/firestore/query-data/queries?authuser=1
        // add a "Listener" when we want the cloud data to be automatically updated to any changes (add, delete, edit) & update our data locally (app)
        let _ = DBService.firestoreDB
            .collection(JobPostCollectionKeys.CollectionKey)
            .whereField(JobPostCollectionKeys.OwnerIdKey, isEqualTo: owner?.userId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    self?.showAlert(title: "Error Fetching Job Posts", message: error.localizedDescription)
                } else if let snapshot = snapshot {
                    self?.jobPosts = snapshot.documents.map { JobPost(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date() }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue to JobPostDetail" {
            guard let indexPath = sender as? IndexPath,
                let jobPostDetailVC = segue.destination as? JobPostDetailViewController else {
                    fatalError("Cannot Segue to JobPostDetailVC")
            }
            let selectedJobPost = jobPosts[indexPath.row]
            // TODO: Set the detail job post here
        } else if segue.identifier == "Segue to EditOwnerProfile" {
            guard let navController = segue.destination as? UINavigationController,
                let editOwnerProfileVC = navController.viewControllers.first as? EditOwnerProfileTableViewController else {
                    fatalError("Failed to Segue to editOwnerProfileVC")
            }
            editOwnerProfileVC.owner = owner
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            fatalError("PostCell not found")
        }
        let currentJobPost = jobPosts[indexPath.row]
        cell.jobDescription.text = currentJobPost.jobDescription
        cell.usernameLabel.text = owner?.displayName
        cell.profileImage.kf.setImage(with: URL(string: currentJobPost.imageURLString), for: .normal, placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Segue to JobPostDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func willSignOut(profileHeaderView: ProfileHeaderView) {
        authservice.signOutAccount()
        showLoginView()
    }
    
    func willEditProfile(profileHeaderView: ProfileHeaderView) {
        performSegue(withIdentifier: "Segue to EditOwnerProfile", sender: nil)
    }
}
