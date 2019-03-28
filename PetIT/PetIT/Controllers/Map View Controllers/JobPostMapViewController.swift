//
//  MapViewController.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class JobPostMapViewController: UIViewController {

    
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var jobPostMap: MKMapView!
    var userLocation = CLLocation()

    class MyAnnotation: MKPointAnnotation {
        var tag: Int!
    }
    
    
    let locationManager = CLLocationManager()
    
    private var jobPosts = [JobPost]() {
        didSet {
            DispatchQueue.main.async {

            }
        }
    }
    
    private var userss = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
//                self.jobListTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice

    override func viewDidLoad() {
        super.viewDidLoad()
        //delegation
        jobPostMap.delegate = self
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            jobPostMap.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            jobPostMap.showsUserLocation = true
        }
        fetchBlogPosts()
    }
    
    func fetchBlogPosts() {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        
        DBService.fetchUser(userId: user.uid) { [weak self] (error, userID) in
            if let _ = error {
                self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
            } else if let userID = userID {
                self?.listener = DBService.firestoreDB
                    .collection(JobPostCollectionKeys.CollectionKey)
                    .addSnapshotListener { [weak self] (snapshot, error) in
                        if let error = error {
                            print("failed to fetch job posts with error: \(error.localizedDescription)")
                        } else if let snapshot = snapshot {
                            
                            self?.jobPosts = snapshot.documents.map { JobPost(dict: $0.data()) }
                                .sorted {(firstObject, secondObject) in
                                    let firstObjectCoordinate = CLLocation(latitude: firstObject.lat, longitude: firstObject.long)
                                    let userCoordinate = CLLocation(latitude: self!.userLocation.coordinate.latitude, longitude: self!.userLocation.coordinate.longitude)
                                    let secondObjectCoordinate = CLLocation(latitude: secondObject.lat, longitude: secondObject.long)
                                    let firstDistance = userCoordinate.distance(from: firstObjectCoordinate)
                                    let secondDistance = userCoordinate.distance(from: secondObjectCoordinate)
                                    
                                    if firstDistance > secondDistance {
                                        return false
                                    } else {
                                        return true
                                    }

                                    
                                    
                                    
                                    

                            
                            }
                            self?.setupAnnotations()

                        }
                        DispatchQueue.main.async {
//                            self?.refreshControl.endRefreshing()
                        }
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Job Post Details" {
            guard let indexPath = sender as? Int,
                let postDVC = segue.destination as? JobPostDetailViewController else {
                    fatalError("cannot segue to postDVC")
                    
            }
            let jobPost = jobPosts[indexPath]
            postDVC.jobPost = jobPost
            
        }
    }

    
    
    
    
    func setupAnnotations(){
        
        
        var count = 0
        
        let allAnnotations = self.jobPostMap.annotations
        self.jobPostMap.removeAnnotations(allAnnotations)
        for jobPost in jobPosts {
            
            print("job number: \(count)")
            let regionRadius: CLLocationDistance = 9000
            let coordinate = CLLocationCoordinate2D.init(latitude: jobPost.lat, longitude: jobPost.long)
            let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            //            let annotation = MKPointAnnotation()
            let annotation = MyAnnotation()
            annotation.coordinate = coordinate
            annotation.title = jobPost.jobDescription
            annotation.subtitle = jobPost.wage
            annotation.tag = count
            
            jobPostMap.setRegion(coordinateRegion, animated: true)
            jobPostMap.addAnnotation(annotation)
            count += 1
            
        }
        let jobCoordinate = CLLocationCoordinate2D(latitude: jobPosts[0].lat, longitude: jobPosts[0].long)
        let myCurrentRegion = MKCoordinateRegion(center: jobCoordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
        jobPostMap.setRegion(myCurrentRegion, animated: true)
        
    }
    
    
    

    
    @IBAction func addJobPostButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}
extension JobPostMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //this kicks off whenever authorization is turned on or off
        print("user changed the authorization")
        let currentLocation = jobPostMap.userLocation
        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        jobPostMap.setRegion(myCurrentRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this kicks off whenever the user's location has noticeably changed
        print("user has changed locations")
        guard let currentLocation = locations.last else {return}
        print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
        userLocation = currentLocation
        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        jobPostMap.setRegion(myCurrentRegion, animated: true)
    }
}
extension JobPostMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let myViewAnnotation = view.annotation as? MyAnnotation else {
            return
        }
        
        let destinationVC = JobPostDetailViewController()
        
        let jobPost = jobPosts[myViewAnnotation.tag]
        destinationVC.jobPost = jobPost
        //        destinationVC.homeDetailView.detailImageView.image = selectedCell.cellImage.image
        
        
        performSegue(withIdentifier: "Show Job Post Details", sender: myViewAnnotation.tag)
    }
}
