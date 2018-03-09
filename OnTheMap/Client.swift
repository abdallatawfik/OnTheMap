//
//  Client.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/29/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import Foundation

// MARK: - Networking Client

class Client : NSObject {
    
    // MARK: Properties
    
    var sessionID: String? = nil
    var userKey: String? = nil
    
    
    // MARK: GET
    
    // Make, start and return a network task according to the given parameters.
    func taskFor(Url url:URL, method: HTTPMethod, header: [String:String], httpBody:String?, resultDataFirstIndex:Int, completionHandler: @escaping (_ result: AnyObject?, _ errorMessage: String?) -> Void) -> URLSessionDataTask {
        /* 1. Configure the request */
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        for (field, value) in header {
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        /* 2. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandler(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("\(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(ResponseErrorMessages.NoStatusCodeError)
                return
            }
            
            guard statusCode >= 200 && statusCode <= 299 else {
                var errorMessage = ResponseErrorMessages.BadStatusCodeError
                
                if statusCode == ResponseErrorCodes.AuthenticationError {
                    errorMessage = ResponseErrorMessages.AuthenticationError
                }
                
                sendError(errorMessage)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(ResponseErrorMessages.NoDataError)
                return
            }
            
            /* subset response data if required! */
            let range = Range(resultDataFirstIndex..<data.count)
            let newData = data.subdata(in: range)
            
            /* 3/4. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData:completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // Given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ errorMessage: String?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, ResponseErrorMessages.ParsingError)
            return
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Construct a URL from host, parameters and path extentions
    func constructURLFrom(host:String, parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = host
        components.path = (withPathExtension ?? "")
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
   
    // Substitute the key with the value that is contained within the method name
    func substituteKeyIn(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}

