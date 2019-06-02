//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 28/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UdacityAPI {
    
    static func PostSession(with email:String, password: String , completion: @escaping ([String:Any]? , Error?) -> ()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(nil , error)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            let result = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            completion(result , nil)
            
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        
        
    }
    
    
    
    static func deleteSession(completion: @escaping (Error?) -> ()){
    
    
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            print(String(data: newData!, encoding: .utf8)!)
            completion(nil)
            
        }
        task.resume()
    
    }
    
    class Parse {
        
        static func postStudentLocation(link: String , locationCoordinate: CLLocationCoordinate2D, locationName:String,completion: @escaping (Error?) -> () ){
            
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    completion(error)
                    return
                }
                print(String(data: data!, encoding: .utf8)!)
                  completion(nil)
            }
            task.resume()
            
            
            
        }
        
        
        
        static func getStudentsLocations(completion: @escaping ([StudentLocation]? , Error?) -> ()) {
            
             let BASE_URL = "https://onthemap-api.udacity.com/v1/StudentLocation"
            
            
//
            var request = URLRequest(url: URL(string: BASE_URL + "?limit=100&order=-updatedAt")!)

            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    
                    completion (nil, error)

                    return
                }
                print(String(data: data!, encoding: .utf8)!)
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    
                    
                   
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    
                    completion (nil, statusCodeError)
                    return
                }
                
                
                if statusCode >= 200 && statusCode < 300 {
                 
                 
//
                    let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                                    guard let results = dict["results"] as? [[String:Any]] else {return}
                    
                                    print("print results " ,results )
                    
                                let resultsData = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    
                            let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: resultsData)
                    
                    Global.shared.studentsLocations = studentsLocations
                      completion(studentsLocations , nil)
                    
                    //
                }
               
                
//

             
                
                
            }
            
            
            task.resume()
            
            
        }
        
      
        
        
    }
    
    
}
