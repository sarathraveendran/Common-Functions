//
//  ErrorDisplayHandlerViewController.swift
//  
//
//  Created by Sarath R on 09/01/17.
//  Copyright © 2017 Sarath R . All rights reserved.
//

import UIKit

class ErrorDisplayViewController: UIViewController {

    // MARK: Declarations
    var webView: UIWebView!
    var errorString: String!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    //MARK: Configure view
    func configureView() {
    
        let rightbarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ErrorDisplayViewController.dismissView(_:)))
        self.navigationItem.rightBarButtonItem = rightbarButton
        
        webView = UIWebView()
        webView.loadHTMLString(errorString, baseURL: nil)
        view.addSubview(webView)
        view.addConstraintsWithFormat("H:|[v0]|", views: webView)
        view.addConstraintsWithFormat("V:|[v0]|", views: webView)

    }
    
    
    // Dismiss view controller
    func dismissView(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

  
}
