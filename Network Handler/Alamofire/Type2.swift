//
//  NetworkHandler.swift
//  
//
//  Created by Sarath R on 09/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SystemConfiguration

class NetworkHandler: NSObject {
    
    // Declarations
    let urls = NetworkUrls()
    
    
    // GET
    func get(url: String, params: [String: Any], showLoader: Bool, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        // Internet connection
        if !hasNetworkAvailable() {
            completionHandler(false, nil)
            return
        }
        
        
        Alamofire.request(makeUrl(url: url), method: .get, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            
            switch response.result {
            
                case .success:
                    if logActivity {
                        
                        if let resultJson = response.result.value {
                            completionHandler(true, resultJson)
                            return
                        }
                        else {
                            if logActivity {
                                print("NetworkHandler reporting -> Error on result parsing")
                            }
                        }
                        completionHandler(true, nil)
                        return
                    }
                
            
                case .failure(let error):
                    
                    completionHandler(true, nil)
                    if logActivity {
                        print("Validation Error")
                        print(response.request ?? "Nothing")  // original URL request
                        print(response.response ?? "Nothing") // HTTP URL response
                        print(response.data ?? "Nothing")     // server data
                        print(response.result)   // result of response serialization
                        print(error)
                        self.loadErrorView(error: "\(response.result)")
                    }

            }
            
        }
        
    }

    
    // GET
    func post(url: String, params: [String: Any], showLoader: Bool, vc: UIViewController? = nil, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        // Internet connection
        if !hasNetworkAvailable() {
            completionHandler(false, nil)
            return
        }
        
        if showLoader {
            if let currentView = vc {
                currentView.showMessage(message: "Please wait...")
            }
        }
        
        
        Alamofire.request(makeUrl(url: url), method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
         
            switch response.result {
                
            case .success:
                
                if logActivity {
                    guard let resultJson = response.result.value else {
                        if logActivity {
                            print("NetworkHandler reporting -> Error on result parsing")
                        }
                        completionHandler(true, nil)
                        return
                    }
                    
                    completionHandler(true, resultJson)
                    return
                }
                
                
            case .failure(let error):
                
                completionHandler(true, nil)
                if logActivity {
                    print(response.request ?? "Nothing")  // original URL request
                    print(response.response ?? "Nothing") // HTTP URL response
                    print(response.data ?? "Nothing")     // server data
                    print(response.result)   // result of response serialization
                    print(error)
                    self.loadErrorView(error: "\(response.result)")
                }
                
            }
            
        }
        
    }
    
    
    // crate url to network call
    func makeUrl(url: String) -> String {
        
        return urls.primaryUrl + url
        
    }
    
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUPPORT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    // Display error view
    func loadErrorView(error: String) {
        
        let errorViewController = ErrorDisplayViewController()
        errorViewController.errorString = error
        let navigation = UINavigationController(rootViewController: errorViewController)
        UIApplication.shared.keyWindow?.rootViewController?.present(navigation, animated: true, completion: nil)
        
    }
    
    
    // Check has Network
    func hasNetworkAvailable() -> Bool  {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}




