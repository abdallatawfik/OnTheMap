//
//  Model.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 8/1/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import Foundation

// MARK: - Model Class

class Model: NSObject {
    
    // MARK: Shared Model
    private var studentInformations = [StudentInformation]()
    
    
    // MARK: Customized Setter and Getter
    
    // Set the shared model with the recieved array of dictionaries
    func setStudentInformations(withStudentLocations studentLocations:[[String:AnyObject]]) {
        // Remove the old data and add the updated one
        studentInformations.removeAll()
        for studentDictionary in studentLocations {
            studentInformations.append(StudentInformation (studentDictionary: studentDictionary))
        }
    }
    
    // Returns all Student Informations
    func getAllStudentInformations() -> [StudentInformation] {
        return studentInformations
    }
    
    // Returns the filtered Student Informations after removing the inappropriate student informations
    func getValidStudentInformations() -> [StudentInformation] {
        return studentInformations.filter({ return $0.validInfo })
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Model {
        struct Singleton {
            static var sharedInstance = Model()
        }
        return Singleton.sharedInstance
    }
}


// MARK: - StudentInformation Structure

struct StudentInformation {
    
    // MARK: - Properties
    
    // All the properties have default values (To avoid the missing information posted by other students!)
    var firstName = "No First Name"
    var lastName = "No Last Name"
    var latitude = 0.0
    var longitude = 0.0
    var mapString = "NA"
    var mediaURL = "No Media URL"
    var objectId = "NA"
    
    // This Bool is used to filter the received information before displaying them
    var validInfo = true
}


// MARK: - StudentInformation (Inits) extension

extension StudentInformation {
    init(studentDictionary:[String:AnyObject]) {
        
        if let _firstName = studentDictionary["firstName"] as? String {
            firstName = _firstName
        } else {
            validInfo = false
        }
        
        if let _lastName = studentDictionary["lastName"] as? String {
            lastName = _lastName
        } else {
            validInfo = false
        }
        
        if let _latitude = studentDictionary["latitude"] as? Double {
            latitude = _latitude
        } else {
            validInfo = false
        }
        
        if let _longitude = studentDictionary["longitude"] as? Double {
            longitude = _longitude
        } else {
            validInfo = false
        }
        
        if let _mediaURL = studentDictionary["mediaURL"] as? String {
            mediaURL = _mediaURL
        } else {
            validInfo = false
        }
        
        if let _objectId = studentDictionary["objectId"] as? String {
            objectId = _objectId
        } else {
            validInfo = false
        }
        
    }
}


// MARK: - StudentInformation (Helpers) extension

extension StudentInformation {
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}
