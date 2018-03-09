//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 8/1/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit
import MapKit


// Base View Controller is a super ViewController for both Map and List ViewControllers
class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var studentInformations:[StudentInformation] {
        get {
            return Model.sharedInstance().getValidStudentInformations()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        subscribeToNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeFromNotifications()
    }
    
    // MARK: - Update Model and UI
    
    @objc func loadData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        Client.sharedInstance().getStudentLocations { (error) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let _ = error {
                    self.showAlertView(message: Alerts.StudentInformationFailedMessage, buttonTitle: Alerts.Dismiss)
                }
            }
        }
    }
    
    @objc func updateUI() {
        // This function must be Overridden
        fatalError("Must Override")
    }
    
    // MARK: - IBActions
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        Client.sharedInstance().deleteSessionID()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    @IBAction func addStudentLocation(_ sender: UIBarButtonItem) {
        Client.sharedInstance().getCurrentStudentLocation { (found, studentInformation, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.showAlertView(message: "\(error!)", buttonTitle: Alerts.Dismiss)
                    return
                }
                
                if found, let studentInformation = studentInformation {
                    let alert = UIAlertController(title: "", message: Alerts.OverwriteMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: Alerts.Overwrite, style: UIAlertActionStyle.default) { (action) in
                        self.performSegue(withIdentifier: SegueIdentifiers.ToPostInfoViewController, sender: studentInformation)
                    })
                    alert.addAction(UIAlertAction(title: Alerts.Cancel, style: UIAlertActionStyle.cancel))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: SegueIdentifiers.ToPostInfoViewController, sender: nil)
                }
            }
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ToPostInfoViewController, let dvc = segue.destination as? InfoPostingViewController, let studentInformation = sender as? StudentInformation {
            dvc.currentStudentInformation = studentInformation
        }
    }
}

// MARK: - BaseViewController (Notifications)

extension BaseViewController {
    
    func subscribeToNotifications() {
        // Student Locations downloaded
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseViewController.updateUI),
                                               name: NSNotification.Name(NotificationNames.StudentLocationsUpdated),
                                               object: Client.sharedInstance())
        
        // New Student Location is available to be downloaded
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseViewController.loadData),
                                               name: NSNotification.Name(NotificationNames.NewStudentLocationsAvailable),
                                               object: nil)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(NotificationNames.StudentLocationsUpdated),
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                 name: NSNotification.Name(NotificationNames.NewStudentLocationsAvailable),
                                                  object: nil)
    }
}
