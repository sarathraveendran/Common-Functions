//
//  UIViewController.swift
//  
//
//  Created by Sarath R on 19/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import Foundation
import UIKit

let activityIndicator = UIActivityIndicatorView()
extension UIViewController {
    
    // Show Loader
    func showIndicator() {
        
        if activityIndicator.isDescendant(of: view) { }
        else {
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
        }
        view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    // Hide Loader
    func hideIndicator() {
        activityIndicator.stopAnimating()
        if activityIndicator.isDescendant(of: view) {
            activityIndicator.removeFromSuperview()
        }
    }
    
    /*
    var activityIndicator: UIActivityIndicatorView! {
        get {
            return self.activityIndicator
        }
        set (newValue) {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activityIndicator.color = Color().themeColor
        }
    }
    */
    
    
    //set page title
    func setPageTitle(title: String) {
        
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // Push view custom navigation item
    func configureNavigationBack() {
        
        let image = UIImage(named: "icon_back_arrow.png")!
        let navBarItem = UIBarButtonItem(image:image,  style: .plain, target: self, action: #selector(UIViewController.didTapNavigationBack(sender:)))
        navigationItem.leftBarButtonItem = navBarItem
        
    }
    
    // Page back Action
    func didTapNavigationBack(sender: AnyObject){
        _ = navigationController?.popViewController(animated: true)
    }

    /*
    // Show messages -> Snackbar alert -> Add TTGSnackbar from repo via cocoapod
    func showMessage(message: String) {
        let snackbar = TTGSnackbar.init(message: message, duration: TTGSnackbarDuration.short)
        snackbar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        snackbar.leftMargin = 8
        snackbar.rightMargin = 8
        snackbar.bottomMargin = 8
        snackbar.backgroundColor = UIColor(hexString: "f06288")
        snackbar.animationDuration = 0.5
        snackbar.animationType = TTGSnackbarAnimationType.fadeInFadeOut
        snackbar.show()
    }
    */
    
    /*
    // Show Activity loading indicator
    func startIndicator() {
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubview(toFront: view)
        activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator.startAnimating()
    }
    */
    
    // Supporting Methods validation
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // Execute after a delay
    func delay(_ delay: Double, _ closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
