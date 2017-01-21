//
//  ShareViewController.swift
//
//
//  Created by Sarath on 10/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        share()
    }
    
    // MARK: Arrange View
    func configureView() {
        
        self.view.backgroundColor = UIColor.white
    }
    
    // Share item
    func share() {
        let objectsToShare = [ShareObjects().text, ShareObjects().appUrl] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
