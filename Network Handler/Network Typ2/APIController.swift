//
//  APIController.swift
//  ModuleTest
//
//  Created by apple on 22/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import Foundation

enum URLRequestType {
    
    case url, json
}



class APIController {
    
    // Declarations
    static let sharedInstance = APIController()
    var urlComponents = URLComponents()
    var apiConnection = ApiConnection.sharedInstance
    
    // MARK: Life cycle mthods
    init() {
        
        // Prepare host
        urlComponents.scheme = apiConnection.scheme // Sample ->  "https"
        urlComponents.host = apiConnection.host // Sample -> "api.nasa.gov"
    }
    
    
    // MARK: Make query item
    func createQueryUrl(methodurl: String, params: Dictionary<String, String>) -> URL? {
        
        // Prepare path
        urlComponents.path = methodurl // Sample -> "/planetary/earth/imagery"
        
        // Add query items
        if params.count > 0 {
            urlComponents.queryItems = []
        }
        
        for item in params {
            let queryItem = URLQueryItem(name: item.key, value: item.value)
            urlComponents.queryItems?.append(queryItem)
        }
        
        return urlComponents.url
    }
    
    
    // Mkae query url from string
    func craeteQueryUrlFromString(methodurl: String, params: Dictionary<String, String>) -> URL?{
        
        // Primary url
        var apiUrl = apiConnection.baseUrl + methodurl
        
        // Add parms & make string
        let parameterArray = params.map { (key, value) -> String in
            return "\(key)=\(value)"
        }
        let queryString = parameterArray.joined(separator: "&")
        
        // Encode url
        guard let encodedQuery = queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else {
            if logActivity {
                print("APIController: craeteQueryUrlFromString - URL Encoding error")
            }
            return nil
        }
        
        // Make final query string
        if let _ = apiUrl.range(of: "?") {
            apiUrl = apiUrl.appending("&" + encodedQuery)
        }
        else {
            apiUrl = apiUrl.appending("?" + encodedQuery)
        }
        
        // The query url
        if let url = URL(string: apiUrl) {
            return url
        }
        
        return nil
    }
    
 
    // ------------------------------UPLOAD POST SUPORT--------------------------//
    // Unique generation
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    // Make multipart form data
    func createBodyWithParameters(parameters: Dictionary<String, String>, filePathKey: String, imageData: Data, boundary: String) -> Data {
        
        var body = Data()
        
        // Add normal params
        if parameters.count > 0 {
            for (key, value) in parameters.enumerated() {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        // Add image data
        let timeStamp = Date().timeIntervalSince1970
        let filename = "myImage_\(timeStamp).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData)
        body.appendString(string:"\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
}


extension Data {
    
    // Multipart POST support
    mutating func appendString(string: String) {
        if let _data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            append(_data)
        }
    }
}
