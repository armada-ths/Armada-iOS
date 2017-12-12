//
//  LinkedinWebViewController.swift
//  Armada
//
//  Created by Ola Roos on 07/07/17.
//  Copyright © 2017 Sami Purmonen. All rights reserved.
//

import UIKit

class LinkedinWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Constants
    //    let linkedInKey = "78p4k1ask5vsdk"        previous key
    //    let linkedInSecret = "BZzUZUFR6r1YZYhf"   previous secret
    let linkedInKey = "78xgv3u01dbkqk"
    let linkedInSecret = "0pmcl2fv2IBeo3en"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAuthorization()
        webView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = ("https://com.appcoda.linkedin.oauth/oauth").addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile"
        //        let scope = "r_fullprofile"
        
        // Create the authorization URL string.
        var authorizationURL: String = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        let request = NSURLRequest(url: URL(string: authorizationURL)!) as URLRequest
        
        webView.loadRequest(request)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        print(url)
        if url.host == "com.appcoda.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]
                requestForAccessToken(code)
            } else {
                print("couldn't find code")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
        return true
    }
    
    func requestForAccessToken(_ authorizationCode: String) {
        print(authorizationCode)
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)
        
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        
        // Indicate that we're about to make a POST request.
        request.httpMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.httpBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        print("requestForAcessToken")
        
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                
                // Convert the received JSON data into a dictionary.
                print(statusCode)
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
                    
                    let accessToken = dataDictionary?["access_token"] as! String
                    
                    UserDefaults.standard.set(accessToken, forKey: "webAccessToken")
                    UserDefaults.standard.synchronize()
                    print("accessToken is \(accessToken)")
                    DispatchQueue.main.async(execute: { () -> Void in
                        // CALL FUNCTION THAT WRITES TO API HERE
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            } else {
                print(statusCode)
            }
        }
        task.resume()
    }
}


