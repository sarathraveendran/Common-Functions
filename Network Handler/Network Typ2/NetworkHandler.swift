//
//  NetworkHandler.swift
//  ModuleTest
//
//  Created by apple on 17/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class NetworkHandler {
    
    // MARK: Declarations
    static let sharedInstance = NetworkHandler()
    let apiConnection = ApiConnection.sharedInstance
    let apiController = APIController.sharedInstance
    
    
    // POST
    func post(_ prefixUrl: String, params: Dictionary<String, Any>, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        // Check connectivity
        if !connectedToNetwork() {
            completionHandler(false, nil)
            return
        }
        
        // Make Url
        let url = URL(string: "\(apiConnection.baseUrl)\(prefixUrl)")
        
        // attach params
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let paramsAsJson = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            request.httpBody = paramsAsJson
        }
        catch {
            if logActivity { print("Network Handler Reports -> Error on json creation") }
            return
        }
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            // Service error
            if error != nil {
                if logActivity { print(error) }
                completionHandler(true, nil)
                return
            }
            
            do {
                // Serialize
                if let responseData = data {
                    let processedData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    completionHandler(true, processedData)
                    return
                }
                
            }
            catch let jsonError {
                if logActivity {
                    print("\nNetwork Handler Reports -> Error: \(jsonError.localizedDescription)\n")
                    let responseAsString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("\n\nResponse as String -> \(responseAsString)\n\n")
                }
            }
            
            // Response nil
            completionHandler(true, nil)
            
            
        }).resume()
        
    }
    
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
    
    
    func get(url: String, params: Dictionary<String, String>, requestType: URLRequestType, showLoader: Bool, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        switch requestType {
            case .url: getUrlRequest(url: url, params: params, showLoader: showLoader, completionHandler: completionHandler)
            case .json: break
        }
        
        
    }
    
    // Download data and keeps in memory -> for file download
    func getUrlRequest(url: String, params: Dictionary<String, String>, showLoader: Bool, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        // Check connectivity
        if !connectedToNetwork() {
            completionHandler(false, nil)
            return
        }
        
        guard let apiUrl = apiController.craeteQueryUrlFromString(methodurl: url, params: params) else {
            if logActivity {
                print("NetworkHandler: GET: getUrlRequest: url makes error")
            }
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           
            if let _error = error {
                if logActivity { print(_error) }
                completionHandler(true, nil)
                return
            }
            
            if let _response = response as? HTTPURLResponse, _response.statusCode == 200, let _data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    completionHandler(true, json)
                }
                catch let jsonError {
                    if logActivity {
                        print("\nNetwork Handler Reports -> Error: \(jsonError.localizedDescription)\n")
                        let responseAsString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("\n\nResponse as String -> \(responseAsString)\n\n")
                    }
                }
                
                // Response nil
                completionHandler(true, nil)
                
            }
            
        }.resume()
        
    }
    
    // Download files via downloadTask
    func download(url: String, params: Dictionary<String, String>, showLoader: Bool, completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        // Check connectivity
        if !connectedToNetwork() {
            completionHandler(false, nil)
            return
        }
        
        guard let apiUrl = apiController.craeteQueryUrlFromString(methodurl: url, params: params) else {
            if logActivity {
                print("NetworkHandler: GET: download: url makes error")
            }
            return
        }
        
        URLSession.shared.downloadTask(with: apiUrl) { (tempUrl, response, error) in
           
            if let _error = error {
                if logActivity { print(_error) }
                completionHandler(true, nil)
                return
            }
           
            if let _response = response as? HTTPURLResponse, _response.statusCode == 200, let url = tempUrl {
              
                do {
                    let data = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    completionHandler(true, json)
                }
                catch let error {
                    if logActivity {
                        print("\nNetwork Handler Reports -> Error: \(error.localizedDescription)\n")
                    }
                }
                
            }
           
            // Response nil
            completionHandler(true, nil)
            
            
        }.resume()
        
    }
    
    
    /* ----                     MULTIPART POST          -------- */
    func mutliPartPost(url: String, params: Dictionary<String, String>, image: UIImage,  completionHandler: @escaping (_ networkStatus: Bool, _ response: Any?) -> ()) {
        
        guard let apiUrl = URL(string: "\(apiConnection.primaryUrlImageUpload)\(url)") else {
            if logActivity {
                print("NetworkHandler: mutliPartPost: Image upload url make error")
            }
            return
        }
        
        // Type
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        // Content
        let boundary = apiController.generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        guard let _ =  imageData else {
            if logActivity { print("NetworkHandler: Multipart post: Error on image data conversion") }
            return
        }
        
        // Make Multipart form data
        request.httpBody = apiController.createBodyWithParameters(parameters: params, filePathKey: "file", imageData: imageData!, boundary: boundary)
        
        // POST
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let _error = error {
                if logActivity {
                    print("NetworkController: MultiPartPost: error \n \(_error.localizedDescription)")
                }
            }
            
            if let _data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    completionHandler(true, json)
                }
                catch let error {
                    if logActivity {
                        print("\nNetwork Handler Reports -> Error: \(error.localizedDescription)\n")
                    }
                }
                
            }
            
            // Response nil
            completionHandler(true, nil)
            
            
        }).resume()
        
    }
    
}
