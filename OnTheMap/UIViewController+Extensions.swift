//
//  UIViewController+Extensions.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 3/9/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//

import UIKit

// MARK: - UIViewController (AlertView) extension

extension UIViewController {
    func showAlertView(title:String = "", message:String, buttonTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewController (OpenURL) extension

extension UIViewController {
    func openURL(_ url:URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            showAlertView(message: Alerts.CannotOpenURLMessage, buttonTitle: Alerts.Dismiss)
        }
    }
}
