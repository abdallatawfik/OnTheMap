//
//  Constants.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/29/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//


// MARK: - Client Constants

extension Client {
    struct Constants {
        
        // MARK: Parse App ID and API Key
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let UdacityApiHost = "www.udacity.com"
        static let UdacityApiPath = "/api"
        static let ParseApiHost = "parse.udacity.com"
        static let ParseApiPath = "/parse/classes"
    }
    
    // MARK: Methods
    struct Methods {
                
        // MARK: Udacity
        static let Session = "/session"
        static let User = "/users/<userKey>"
        
        // MARK: Parse
        static let StudentLocation = "/StudentLocation"
        static let PutStudentLocation = "/StudentLocation/<objectId>"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserKey = "userKey"
        static let ObjectID = "objectId"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // General
        static let ApiKey = "X-Parse-REST-API-Key"
        static let AppID = "X-Parse-Application-Id"
        
        // Student Locations
        static let Limit = "limit"
        static let Order = "order"
        static let UniqueKey = "where"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        
        // Student Locations
        static let Limit = "100"
        static let Order = "-updatedAt"
        static let UniqueKey = "{\"uniqueKey\":\"<userKey>\"}"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        // Udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // Parse (Student Location)
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let UserKey = "key"
        
        // MARK: Public User Data
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        // MARK: Student Location
        static let Results = "results"        
    }
    
    // MARK: Header Keys
    struct HeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let CookieName = "XSRF-TOKEN"
        static let CookieHeaderKey = "X-XSRF-TOKEN"
    }
    
    // MARK: Header Values
    struct HeaderValues {
        static let Accept = "application/json"
        static let ContentType = "application/json"
    }
    
    // MARK: Response Error Codes
    struct ResponseErrorCodes {
        static let AuthenticationError = 403
    }
    
    // MARK: Response Error Messages
    struct ResponseErrorMessages {
        static let NoStatusCodeError = "Your request didn't return a status code!"
        static let BadStatusCodeError = "Your request returned a status code other than 2xx!"
        static let AuthenticationError = "Invalid Email or Password"
        static let NoDataError = "No data was returned by the request!"
        static let ParsingError = "Could not parse the data as JSON"
    }
    
    // MARK: HTTP Request Methods
    enum HTTPMethod:String {
        case Get = "GET"
        case Post = "POST"
        case Put = "PUT"
        case Delete = "DELETE"
    }
}

// MARK: - Global Constants


// MARK: General Urls

struct GeneralUrls {
    static let signUpUrl = "https://www.udacity.com/account/auth#!/signup"
}

// MARK: Notifications Names

struct NotificationNames {
    static let StudentLocationsUpdated = "StudentLocationsUpdated"
    static let NewStudentLocationsAvailable = "NewStudentLocationsAvailable"
}


// MARK: Segue Identifiers

struct SegueIdentifiers {
    static let ToTabBarViewController = "showTabBarController"
    static let ToPostInfoViewController = "postInfoViewController"
}

// MARK: Reuse Identifiers

struct ReuseIdentifiers {
    static let MapPin = "pin"
    static let TableViewCell = "StudentsTableViewCell"
}

// MARK: Alerts

struct Alerts {
    
    // Actions
    static let Dismiss = "Dismiss"
    static let Cancel = "Cancel"
    static let Overwrite = "Overwrite"
    
    // Messages
    static let EmptyEmailOrPasswordMessage = "Empty Email or Password"
    static let CannotOpenURLMessage = "Cannot open this URL"
    static let OverwriteMessage = "You have already posted a Student Location. Would you like to overwrite your current location?"
    static let StudentInformationFailedMessage = "Faild to fetch Student Informations"
    static let EmptyLocationMessage = "Empty location!"
    static let LocationNotFoundMessage = "No response!"
    static let InvalidMediaURLMessage = "Invalid media url!"
    static let EmptyMediaURLMessage = "Empty media url!"
    
    // Titles
    static let LocationNotFoundTitle = "Location Not Found"
}
