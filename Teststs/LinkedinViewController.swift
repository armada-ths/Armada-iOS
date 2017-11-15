//
//  LinkedinViewController.swift
//  Armada
//
//  Created by Ola Roos on 07/07/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class LinkedinViewController: UIViewController {
    
    func pushLIbutton(){
        var haveLIinfo: Bool = false
        if let profileString = UserDefaults.standard.value(forKey: "LIprofile") {
            haveLIinfo = true
            print("profileString is \(profileString)")
        }
        if haveLIinfo {
            print("you already logged in :)")
            print(UserDefaults.standard.value(forKey: "LIprofile"))
        } else {
            let haveApp = LinkedinAppExists()
            if haveApp {
                // TRY TO GET APP TOKEN
                getAppToken()
            } else {
                // TRY TO GET WEB TOKEN
                getWebToken()
            }
            
        }
    }
    
    func LinkedinAppExists() -> Bool {
        let appName = "LinkedIn"
        let appScheme = "\(appName)://app"
        let appUrl = URL(string: appScheme)
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            return true
            
        } else {
            return false
        }
    }
    
    func getAppToken() -> String {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {(returnState) -> Void in
            print("success called!")
            if LISDKSessionManager.hasValidSession() {
                let accessToken = LISDKSessionManager.sharedInstance().session.accessToken.accessTokenValue
                UserDefaults.standard.set(accessToken, forKey: "appAccessToken")
                self.appGetProfile(accessToken: accessToken as! String)
            }
        }, errorBlock: {(error) -> Void in
            print("Error: \(error)")
        })
        return ""
    }
    
    func appGetProfile(accessToken: String) {
        // Specify the URL string that we'll get the profile info from.
        let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
        
        // Initialize a mutable URL request object.
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        
        // Indicate that this is a GET request.
        request.httpMethod = "GET"
        
        // Add the access token as an HTTP header field.
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("it-IT", forHTTPHeaderField: "Accept-Language")
        request.addValue("msdk", forHTTPHeaderField: "x-li-src")
        print(request.httpBody)
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            print(statusCode)
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    print(dataDictionary)
                    let profileURLString = dataDictionary["publicProfileUrl"] as! String
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        UserDefaults.standard.set(profileURLString, forKey: "LIprofile")
                        // CALL FUNCTION HERE THAT SENDS DATA TO API
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
    
    func getWebToken() {
        let webview = self.storyboard?.instantiateViewController(withIdentifier: "liwebview") as! LinkedinWebViewController
        self.present(webview, animated: true, completion: nil)
    }
    
    func webGetProfile(accessToken: String) {
        // Specify the URL string that we'll get the profile info from.
        let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
        
        // Initialize a mutable URL request object.
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        
        // Indicate that this is a GET request.
        request.httpMethod = "GET"
        
        // Add the access token as an HTTP header field.
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("it-IT", forHTTPHeaderField: "Accept-Language")
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    print(dataDictionary)
                    let profileURLString = dataDictionary["publicProfileUrl"] as! String
                    DispatchQueue.main.async(execute: { () -> Void in
                        UserDefaults.standard.set(profileURLString, forKey: "LIprofile")
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check for liprofile
        //        if let _ = UserDefaults.standard.object(forKey: "LIprofile"){
        //            // MAKE CALL TO API HERE
        //        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
