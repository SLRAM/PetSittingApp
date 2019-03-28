//
//  AddLocationViewController.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/28/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

import CoreLocation

import MapKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var center = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        //delegation
        locationManager.delegate = self
        myMapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //we need to say how accurate the data should be
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            myMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            myMapView.showsUserLocation = true
        }
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11)
//        myMapView.addAnnotation(annotation)
    }
    

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //pass center to location
    }

    
    
    
    
}
extension AddLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //this kicks off whenever authorization is turned on or off
        print("user changed the authorization")
        let currentLocation = myMapView.userLocation
        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        myMapView.setRegion(myCurrentRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this kicks off whenever the user's location has noticeably changed
        print("user has changed locations")
        guard let currentLocation = locations.last else {return}
        print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
        
        let myCurrentRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        myMapView.setRegion(myCurrentRegion, animated: true)
    }
    
}
extension AddLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
        print(center)
    }

}
