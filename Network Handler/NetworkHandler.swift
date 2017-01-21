//
//  NetworkHandler.swift
//  
//
//  Created by Sarath on 19/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class NetworkHandler {
    static let sharedInstance = NetworkHandler()
    
    // Declaration
    let urls = APIUrls.sharedInstance
    
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    func get(_ url: String, params: Dictionary<String, Any>, showLoader: Bool, vc: UIViewController, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        if !connectedToNetwork() {
            if logActivity {
                if logActivity { print("\nNetworkHandler: Get: No internect connection\n") }
                completionHandler(false, nil)
                return
            }
        }
        
        if showLoader {
            vc.showIndicator()
        }
        
        // Make url
        guard let apiUrl = URL(string: "\(urls.primaryUrl)\(url)") else {
            if logActivity { print("\nNetworkHandler: Get: Url make error\n") }
            completionHandler(true, nil)
            return
        }
        
        
        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            
            if showLoader {
                vc.hideIndicator()
            }
            
            if let _error = error {
                if logActivity { print("NetworkHandler: Get:\n \(_error)\n") }
                //loadErrorView(error: _error)
            }
            
            do {
                if let _data = data {
                    let json = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    completionHandler(true, json)
                    return
                }
            }
            catch let jsonError {
                if logActivity { print("NetworkHandler: Get: \(jsonError)")
                    print("\nNetwork Handler: Get \n\(jsonError.localizedDescription)\n")
                    let responseAsString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("\n\nResponse as String \n \(responseAsString)\n\n")
                }
            }
           
            completionHandler(true, nil)
            
        }.resume()
        
    }
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    func post(url: String, params: Dictionary<String, Any>, showLoader: Bool, vc: UIViewController, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        if !connectedToNetwork() {
            if logActivity { print("\nNetworkHandler: Post: No internect connection\n") }
            completionHandler(false, nil)
            return
        }
        
        if showLoader {
            vc.showIndicator()
        }
        
        // Make url
        guard let apiUrl = URL(string: "\(urls.primaryUrl)\(url)") else {
            if logActivity { print("\nNetworkHandler: Get: Url make error\n") }
            completionHandler(true, nil)
            return
        }
        
        let request = NSMutableURLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set params
        if params.count > 0 {
            do {
                let jsonParams = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                request.httpBody = jsonParams
            }
            catch let error {
                if logActivity { print("\nNetworkHandler: Post: parameter json encode error \n\(error)\n") }
            }
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let _error = error {
                if logActivity { print("NetworkHandler: Post:\n \(_error)\n") }
                //loadErrorView(error: _error)
            }
            
            do {
                
                if let _data = data {
                    let json = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    completionHandler(true, json)
                }
            }
            catch let jsonError {
                if logActivity {
                    print("\nNetwork Handler: Post \n\(jsonError.localizedDescription)\n")
                    let responseAsString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("\n\nResponse as String \n \(responseAsString)\n\n")
                }
            }
            
            completionHandler(true, nil)
            
        }.resume()
        
    }
    
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    // Connectivity
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

    // Display error view
    func loadErrorView(error: String) {
        
        let errorViewController = ErrorDisplayViewController()
        errorViewController.errorString = error
        let navigation = UINavigationController(rootViewController: errorViewController)
        UIApplication.shared.keyWindow?.rootViewController?.present(navigation, animated: true, completion: nil)
    }
    
   
}
