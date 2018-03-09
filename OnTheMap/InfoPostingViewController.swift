//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/31/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController {
    
    enum ViewState: Int { case LocationView, MediaUrlView }
    
    // MARK: - Properties
    
    let annotation = MKPointAnnotation()
    // If the user has posted their information before, this variable will be set with the current info
    var currentStudentInformation:StudentInformation? = nil
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var mediaUrlView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaUrlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI(.LocationView)
    }
    
    // MARK: - IBActions
    
    @IBAction func findOnTheMap() {
        if let searchText = locationTextField.text, !searchText.isEmpty {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchText
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    guard error == nil else {
                        self.showAlertView(title: Alerts.LocationNotFoundTitle, message: "\(error!.localizedDescription)", buttonTitle: Alerts.Dismiss)
                        return
                    }
                    
                    guard let response = response else {
                        self.showAlertView(title: Alerts.LocationNotFoundTitle, message: Alerts.LocationNotFoundMessage, buttonTitle: Alerts.Dismiss)
                        return
                    }
                    
                    let annotation = self.annotation
                    annotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
                    annotation.title = response.mapItems.first?.name
                
                    self.configureUI(.MediaUrlView)
                    
                    self.mapView.addAnnotation(annotation)
                    self.mapView.showAnnotations([annotation], animated: true)
                }
            }
        } else {
             showAlertView(message: Alerts.EmptyLocationMessage, buttonTitle: Alerts.Dismiss)
        }
    }
    
    @IBAction func submit() {
        if let mediaUrl = mediaUrlTextField.text, !mediaUrl.isEmpty {
            if UIApplication.shared.canOpenURL(URL(string: mediaUrl)!) {
                
                // If it is the first time to post information the following variables will be updated inside the Client
                var firstName = "NA"
                var lastName = "NA"
                var objectId = "NA"
                
                if let currentStudentInformation = currentStudentInformation {
                    firstName = currentStudentInformation.firstName
                    lastName = currentStudentInformation.lastName
                    objectId = currentStudentInformation.objectId
                }
                
                // Updated student information to be sent to the server
                let postingStudentInformation = StudentInformation(firstName: firstName, lastName: lastName, latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude, mapString: self.locationTextField.text!, mediaURL: mediaUrl, objectId: objectId, validInfo: true)
                
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                
                Client.sharedInstance().updateStudentLocation(currentStudentInformation, withStudentInformation: postingStudentInformation, completionHandler: { (error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        
                        guard error == nil else {
                            self.showAlertView(message: "\(error!)", buttonTitle: Alerts.Dismiss)
                            return
                        }
                        
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.NewStudentLocationsAvailable), object: self)
                        }
                    }
                    
                })
            } else {
                showAlertView(message: Alerts.InvalidMediaURLMessage, buttonTitle: Alerts.Dismiss)
            }
        } else {
            showAlertView(message: Alerts.EmptyMediaURLMessage, buttonTitle: Alerts.Dismiss)
        }
    }
    
    @IBAction func cancelPostingInfo() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Configuration
    
    func configureUI(_ viewState: ViewState) {
        switch(viewState) {
        case .LocationView:
            locationStackView.isHidden = false
            mediaUrlView.isHidden = true
        case .MediaUrlView:
            locationStackView.isHidden = true
            mediaUrlView.isHidden = false
        }
    }

}

// MARK: - InfoPostingViewController (TextField) delegate

extension InfoPostingViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case locationTextField:
            findOnTheMap()
        case mediaUrlTextField:
            submit()
        default:
            break
        }
        return true
    }
}
