//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 3/9/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//

import Foundation

// MARK: - Udacity Api (Convenient Resource Methods)

extension Client {
    
    // MARK: Session ID
    
    func getSessionID(forEmail email:String, password:String, completionHandler: @escaping (_ success:Bool, _ error:String?) -> Void) {
        let url = constructURLFrom(host: Constants.UdacityApiHost, parameters: nil, withPathExtension: Constants.UdacityApiPath + Methods.Session)
        let header = [HeaderKeys.Accept:HeaderValues.Accept,
                      HeaderKeys.ContentType:HeaderValues.ContentType]
        let httpBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(email)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        let _ = taskFor(Url: url, method: .Post, header: header, httpBody: httpBody, resultDataFirstIndex: 5)
        { (result, error) in
            
            guard error == nil else {
                completionHandler(false, error!)
                return
            }
            
            if let result = result {
                if let session = result[JSONResponseKeys.Session] as? [String:AnyObject], let sessionID = session[JSONResponseKeys.SessionID] as? String, let account = result[JSONResponseKeys.Account] as? [String:AnyObject], let userKey = account[JSONResponseKeys.UserKey] as? String {
                    self.sessionID = sessionID
                    self.userKey = userKey
                    completionHandler(true, nil)
                    return
                }
            }
        }
    }
    
    func deleteSessionID() {
        let url = constructURLFrom(host: Constants.UdacityApiHost, parameters: nil, withPathExtension: Constants.UdacityApiPath + Methods.Session)
        var header = [String:String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == HeaderKeys.CookieName { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            header[HeaderKeys.CookieHeaderKey] = xsrfCookie.value
        }
        
        let _ = taskFor(Url: url, method: .Delete, header: header, httpBody: nil, resultDataFirstIndex: 5)
        { (result, error) in
            
            guard error == nil else {
                print("Failed to delete Session ID with error: \(error!)")
                return
            }
            
            if let result = result {
                self.sessionID = nil
                self.userKey = nil
                print("Session deleted: '\(result)'")
            }
        }
    }
    
    
    // MARK: Udacity Public User Data
    
    func getPublicUserData(completionHandler: @escaping (_ firstname:String?, _ lastname:String?, _ error:String?) -> Void) {
        let userMethod = substituteKeyIn(Methods.User, key: URLKeys.UserKey, value: userKey!)
        let url = constructURLFrom(host: Constants.UdacityApiHost, parameters: nil, withPathExtension: Constants.UdacityApiPath + userMethod!)
        
        let _ = taskFor(Url: url, method: .Get, header: [:], httpBody: nil, resultDataFirstIndex: 5) { (result, error) in
            
            guard error == nil else {
                completionHandler(nil, nil, error!)
                return
            }
            
            if let result = result {
                
                if let user = result[JSONResponseKeys.User] as? [String:AnyObject], let firstname = user[JSONResponseKeys.FirstName] as? String, let lastname = user[JSONResponseKeys.LastName] as? String {
                    completionHandler(firstname, lastname, nil)
                    return
                }
            }
        }
    }
}
