//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/30/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Loading data for the first time
        loadData()
    }
    
    // MARK: - Update UI
    
    override func updateUI() {
        addAnnotations(forLocations: studentInformations)
    }
}

// MARK: - MapViewController (MapView) delegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifiers.MapPin) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ReuseIdentifiers.MapPin)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation, let urlString = annotation.subtitle, let url = URL(string: urlString!) {
                openURL(url)
            }
        }
    }
    
    func addAnnotations(forLocations locations:[StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        
        for studentInformation in locations {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(studentInformation.latitude), longitude: CLLocationDegrees(studentInformation.longitude))
            annotation.title = studentInformation.getFullName()
            annotation.subtitle = studentInformation.mediaURL
            
            annotations.append(annotation)
        }
        
        // Remove old annotations if any then add the new ones
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}
