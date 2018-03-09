//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/29/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IBActions
    
    @IBAction func login() {
        if let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            Client.sharedInstance().getSessionID(forEmail: email, password: password) { (success, error) in
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = true
                    self.loginButton.alpha = 1
                    self.activityIndicator.stopAnimating()
                    
                    guard error == nil else {
                        self.showAlertView(message: "\(error!)", buttonTitle: Alerts.Dismiss)
                        return
                    }
                    
                    if success {
                        self.performSegue(withIdentifier: SegueIdentifiers.ToTabBarViewController, sender: nil)
                    }
                }
            }
        }
        else {
            showAlertView(message: Alerts.EmptyEmailOrPasswordMessage, buttonTitle: Alerts.Dismiss)
        }
    }
    
    @IBAction func signUp() {
        openURL(URL(string: GeneralUrls.signUpUrl)!)
    }
}

// MARK: - LoginViewController (TextField) delegate

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            passwordTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            login()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

