//
//  JobListViewController.swift
//  PetIT
//
//  Created by Manny Yusuf on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import CoreLocation
import MapKit

class JobListViewController: UIViewController {

    @IBOutlet weak var jobListSearchBar: UISearchBar!
    @IBOutlet weak var jobListTableView: UITableView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()

    
    private var jobPosts = [JobPost]() {
        didSet {
            DispatchQueue.main.async {
                self.jobListTableView.reloadData()
                let topPath = IndexPath(row: NSNotFound, section: 0)
                self.jobListTableView.scrollToRow(at: topPath, at: UITableView.ScrollPosition.top, animated: true)
            }
        }
    }
    
    private var userss = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
                self.jobListTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        jobListTableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchBlogPosts), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
//            myMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
//            myMapView.showsUserLocation = true
        }
        
        jobListTableView.dataSource = self
        jobListTableView.delegate = self
        jobListTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        authservice.authserviceSignOutDelegate = self
        fetchBlogPosts()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchBlogPosts()
    }
    
    @objc private func fetchBlogPosts() {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        
        DBService.fetchUser(userId: user.uid) { [weak self] (error, userID) in
            if let _ = error {
                self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
            } else if let userID = userID {
                
                self?.refreshControl.beginRefreshing()
                self?.listener = DBService.firestoreDB
                    .collection(JobPostCollectionKeys.CollectionKey)
                    .addSnapshotListener { [weak self] (snapshot, error) in
                        if let error = error {
                            print("failed to fetch job posts with error: \(error.localizedDescription)")
                        } else if let snapshot = snapshot {
                            
                            self?.jobPosts = snapshot.documents.map { JobPost(dict: $0.data()) }
                                .sorted { $0.createdDate.date() > $1.createdDate.date() }
                        }
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Job Post Details" {
            guard let indexPath = sender as? IndexPath,
                let cell = jobListTableView.cellForRow(at: indexPath) as? PostCell,
                let postDVC = segue.destination as? JobPostDetailViewController else {
                    fatalError("cannot segue to postDVC")
                    
            }
            let jobPost = jobPosts[indexPath.row]
            postDVC.jobPost = jobPost
            
        }
    }

}
extension JobListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = jobListTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            fatalError("PostCell not found")
        }
        let jobPost = jobPosts[indexPath.row]
        let coordinate0 = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let coordinate1 = CLLocation(latitude: jobPost.lat, longitude: jobPost.long)
        let distanceInMiles = (coordinate0.distance(from: coordinate1))/1609.344
        let roundedDistance = String(format: "%.2f", distanceInMiles)
        cell.selectionStyle = .none
        if !jobPost.status.isEmpty {
            cell.pendingStatus.setTitle(jobPost.status, for: .normal)
            cell.pendingStatus.setTitleColor(.green, for: .normal)
        }
        cell.jobDescription.text = jobPost.jobDescription
        cell.zipcodeLabel.text = "Distance: \(roundedDistance) miles"
        fetchPostCreator(userId: jobPost.ownerId, cell: cell, jobPost: jobPost)
        return cell
    }
    
    private func fetchPostCreator(userId: String, cell: PostCell, jobPost: JobPost) {
        DBService.fetchUser(userId: userId) { (error, postCreator) in
            if let error = error {
                print("failed to fetch blog creator with error: \(error.localizedDescription)")
            } else if let postCreator = postCreator {
                guard let userPhoto = postCreator.photoURL else {return}
                cell.usernameLabel.text = postCreator.displayName
                cell.profileImage.kf.setImage(with: URL(string: userPhoto) ,for: .normal, placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
            }
        }
        
    }
}

extension JobListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.SitterCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Job Post Details", sender: indexPath)
    }
}

extension JobListViewController: AuthServiceSignOutDelegate {
    func didSignOut(_ authservice: AuthService) {
        listener.remove()
        showLoginView()
    }
    func didSignOutWithError(_ authservice: AuthService, error: Error) {}
}

extension JobListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //this kicks off whenever authorization is turned on or off
        print("user changed the authorization")
//        let currentLocation = myMapView.userLocation
//        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//
//        myMapView.setRegion(myCurrentRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("user has changed locations")
        guard let currentLocation = locations.last else {return}
        print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
        
        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        userLocation = currentLocation.coordinate
    }
}
extension JobListViewController: UISearchBarDelegate {
    
}
