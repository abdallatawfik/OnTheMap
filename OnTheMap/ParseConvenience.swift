//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 3/9/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//

import Foundation

// MARK: - Parse Api (Convenient Resource Methods)

extension Client {
    
    // MARK: GET Student Locations
    
    func getStudentLocations(completionHandler: @escaping (_ error:String?) -> Void) {
        let parameters = [ParameterKeys.Limit:ParameterValues.Limit,
                          ParameterKeys.Order:ParameterValues.Order]
        let url = constructURLFrom(host: Constants.ParseApiHost, parameters: parameters as [String : AnyObject]?, withPathExtension: Constants.ParseApiPath + Methods.StudentLocation)
        let header = [ParameterKeys.AppID:Constants.AppID,
                      ParameterKeys.ApiKey:Constants.ApiKey]
        
        let _ = taskFor(Url: url, method: .Get, header: header, httpBody: nil, resultDataFirstIndex: 0) { (result, error) in
            
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            if let result = result, let studentLocations = result[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                
                Model.sharedInstance().setStudentInformations(withStudentLocations: studentLocations)
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.StudentLocationsUpdated), object: self)
                }
                completionHandler(nil)
                return
            }
        }
    }
    
    func getCurrentStudentLocation(completionHandler:@escaping (_ found:Bool, _ studentInformation: StudentInformation?, _ error:String?) -> Void) {
        let uniqueKeyQuery = substituteKeyIn(ParameterValues.UniqueKey, key: URLKeys.UserKey, value: userKey!)
        let parameters = [ParameterKeys.UniqueKey:uniqueKeyQuery]
        let url = constructURLFrom(host: Constants.ParseApiHost, parameters: parameters as [String : AnyObject]?, withPathExtension: Constants.ParseApiPath + Methods.StudentLocation)
        let header = [ParameterKeys.AppID:Constants.AppID,
                      ParameterKeys.ApiKey:Constants.ApiKey]
        
        let _ = taskFor(Url: url, method: .Get, header: header, httpBody: nil, resultDataFirstIndex: 0) { (result, error) in
            
            guard error == nil else {
                completionHandler(false, nil, error!)
                return
            }
            
            if let result = result, let students = result[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                if let student = students.first {
                    
                    let studentInformation = StudentInformation(studentDictionary: student)
                    completionHandler(true, studentInformation, nil)
                    return
                } else {
                    completionHandler(false, nil, nil)
                }
            } else {
                completionHandler(false, nil, ResponseErrorMessages.NoDataError)
            }
        }
    }
    
    
    // MARK: POST and PUT Student Location
    
    func updateStudentLocation(_ oldStudentInformation:StudentInformation?, withStudentInformation newStudentInformation:StudentInformation, completionHandler: @escaping (_ error:String?) -> Void) {
        func startRequest(methodPath:String, httpMethod:HTTPMethod, studentInformation:StudentInformation) {
            let url = constructURLFrom(host: Constants.ParseApiHost, parameters: nil, withPathExtension: Constants.ParseApiPath + methodPath)
            let header = [ParameterKeys.AppID:Constants.AppID,
                          ParameterKeys.ApiKey:Constants.ApiKey,
                          HeaderKeys.ContentType:HeaderValues.ContentType]
            let httpBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(userKey!)\", \"\(JSONBodyKeys.FirstName)\": \"\(studentInformation.firstName)\", \"\(JSONBodyKeys.LastName)\": \"\(studentInformation.lastName)\",\"\(JSONBodyKeys.MapString)\": \"\(studentInformation.mapString)\", \"\(JSONBodyKeys.MediaURL)\": \"\(studentInformation.mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(studentInformation.latitude), \"\(JSONBodyKeys.Longitude)\": \(studentInformation.longitude)}"
            
            let _ = taskFor(Url: url, method: httpMethod, header: header, httpBody: httpBody, resultDataFirstIndex: 0)
            { (result, error) in
                guard error == nil else {
                    completionHandler(error!)
                    return
                }
                
                if let _ = result {
                    completionHandler(nil)
                }
            }
        }
        
        if let oldStudentInformation = oldStudentInformation {
            let putStudentLocationMethod = substituteKeyIn(Methods.PutStudentLocation, key: URLKeys.ObjectID, value: oldStudentInformation.objectId)!
            
            startRequest(methodPath: putStudentLocationMethod, httpMethod: .Put, studentInformation: newStudentInformation)
        } else {
            getPublicUserData { (firstname, lastname, error) in
                
                guard error == nil else {
                    completionHandler(error!)
                    return
                }
                
                if let firstname = firstname, let lastname = lastname {
                    var newStudentInformation = newStudentInformation
                    newStudentInformation.firstName = firstname
                    newStudentInformation.lastName = lastname
                    
                    startRequest(methodPath: Methods.StudentLocation, httpMethod: .Post, studentInformation: newStudentInformation)
                }
            }
        }
    }
}
