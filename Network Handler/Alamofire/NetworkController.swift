//
//  NetworkController.swift
//  
//
//  Created by Sarath R on 04/10/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import Foundation
import Alamofire
import AEXML

//Common Access - Declaration
let logActivity = true
let headers: HTTPHeaders = ["Accept": "application/xml"]

class NetworkController {

    // Declarations
    let serverUrls = ServerUrls()
    let alertMessages = Strings()
    
    // Remove Previous files
    func clearFileCache() {
        
        do {
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filesPath = documentsURL.appendingPathComponent("FilesCache")
            
            let allFiles = try fileManager.contentsOfDirectory(atPath: filesPath.path)
            for file in allFiles {
                let fullFilePath = filesPath.appendingPathComponent(file)
                do {
                    try fileManager.removeItem(atPath: fullFilePath.path)
                }
                catch {
                    if logActivity {
                        print("Cannot remove file from FilesCache Directory\n")
                        print("Error: \(error)")
                    }
                }
            }
            
        }
        catch {
            if logActivity {
                print("NetworkController: Caught error on Files removal")
            }
        }
        
    }
    
    
    // Get request
    func get(url: String, parameters: NSDictionary, showLoader: Bool? = false, logResponse: Bool? = false, completionHandler: @escaping (_ networkStatus: Bool, _ result: Data?) -> ()) {
       
        //No internet connection
        if !(Network().connectedToNetwork()) {
            completionHandler(false, nil)
            return
        }
        
        if logActivity {
            print("Get -> Request trigerred")
        }
        
        var snackbar: TTGSnackbar?
        if showLoader! {
            snackbar = TTGSnackbar(message: "Please wait...", duration: TTGSnackbarDuration.forever)
            snackbar?.show()
        }
        
        Alamofire.request(url, parameters: parameters as? Parameters, encoding: URLEncoding.default).validate().responseData { response in
            
            switch response.result {
                
            case .success:
                
                // Dismiss default loader
                if showLoader! && snackbar != nil {
                    snackbar?.dismiss()
                }
                
                if let data = response.data {
                    
                    if let utf8Text = String(data: data, encoding: .utf8), logResponse! {
                        print("Request: \(response.request)", terminator: "\n\n")
                        print("Data: \(utf8Text)")
                    }
                    
                    if logActivity {
                        print("Network request completed!")
                    }
                    
                    completionHandler(true, data)
                    
                }
                else if logActivity || logResponse! {
                    print("Response data may be nil! ->  \(response.data)")
                }
                
            case .failure(let error):
               
                // Dismiss default loader
                if showLoader! && snackbar != nil {
                    snackbar?.dismiss()
                }
                
                if logActivity {
                    print("Request: \(response.request) \n Response: \(response.response) \n Error: \(error)")
                }
                
                // Updating to -> origin 
                completionHandler(true, nil)
                
            }
            
        }
        
    }
    
    

    func getAsDowload(url: String, parameters: NSDictionary, logResponse: Bool? = false, completionHandler: @escaping (_ networkStatus: Bool, _ result: Data?) -> ()) {
        
        //No internet connection
        if !(Network().connectedToNetwork()) {
            completionHandler(false, nil)
            return
        }
        
        if logActivity {
            print("\nGet -> Download request trigerred\n")
        }
        
        // Remove Cache -> All Previous files
        clearFileCache()
        
        // Set Destination Path
        let destination: DownloadRequest.DownloadFileDestination = { (temporaryURL, response) in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let pathComponent = response.suggestedFilename
            let downloadPath = documentsURL.appendingPathComponent("FilesCache")
            let fileURL = downloadPath.appendingPathComponent(pathComponent!)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, parameters: parameters as? Parameters, encoding: URLEncoding.default, to: destination)
            .downloadProgress{ progress in
                if logActivity {
                    //print(progress)
                }
            }
            .responseData { response in
                
                if response.result.isSuccess, let filePath = response.destinationURL {
                    
                    do {
                        
                        // Stored Path
                        let data = try Data(contentsOf: filePath)
                        
                        // Unzip the zipped
                        let decompressedData: Data
                        if data.isGzipped {
                            decompressedData = try! data.gunzipped()
                        }
                        else {
                            decompressedData = data
                        }
                        
                        if logResponse! {
                            
                            if logActivity {
                                print("Path: \(filePath.path)\n")
                                print("Before compression: \(data)\n")
                                print("Decompressed size: \(decompressedData)\n")
                            }
                            let loginResultXML = try AEXMLDocument(xml: decompressedData, options: parseOptions())
                            print("Decompressed XML: \(loginResultXML.xml)")
                            
                        }
                        if logActivity {
                            print("File download completed!")
                        }
                        
                        // Updating to -> origin
                        completionHandler(true, decompressedData)
                        
                        
                    }
                    catch {
                        
                        if logActivity {
                            print("Network Controller: File Download-> Error on FileRead/Decompression -> error: \(error)")
                        }
                        // Updating to -> origin
                        completionHandler(true, nil)
                        
                    }
                    
                }
                else {
                    
                    if logActivity {
                        print("Network Controller: Download file -> Failure")
                    }
                    // Updating to -> origin
                    completionHandler(true, nil)
                    
                }
                
            }
        
    }
    
   
}
