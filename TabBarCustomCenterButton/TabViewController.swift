//
//  MainTabViewController.swift
//  
//
//  Created by Sarath on 12/10/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import UIKit
import Toast_Swift

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    // Declaration
    let color = Color()
    let centerView = UIView()
    let centerButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureController()
       
    }

    
    // Style View
    func configureView() {
        
        
        // Change seppartor
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // Tab color
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = color.statusBarColor
        self.tabBar.tintColor = color.themeColor
        
    }
    
    
    // Set tab controller
    func configureController() {
        
        // Tabbar Delegate
        self.delegate = self
        
        // Frist Tab
        let tabOne = UIViewController()
        let tabOneBarItem = UITabBarItem(title: nil, image: UIImage(named: "imag0"), selectedImage: UIImage(named: "imag1"))
        tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        // Second Tab - Dummy Tab - Center Overlays this Tab
        let tabTwo = UIViewController()
        let tabTwoBarItem2 = UITabBarItem()
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Third tab
        let tabThree = UIViewController()
        let tabThreeItem = UITabBarItem(title: nil, image: UIImage(named: "image0"), selectedImage: UIImage(named: "image1"))
        tabThreeItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabThree.tabBarItem = tabThreeItem
        
        
        // Make Tabbar
        self.viewControllers = [tabOne, tabTwo, tabThree]
        self.tabBar.itemPositioning = UITabBarItemPositioning.fill
        
        // Center Button
        self.addCenterButtonWithImage(buttonImage: UIImage(named: "tab_center")!, highlightImage: UIImage(named: "tab_center")!)
        
    }
    
    
    // Create a custom UIButton and add it to the center of our tab bar
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage:UIImage) {
    
        // Arrage center view for tab bar
        centerView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        centerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        centerView.backgroundColor = UIColor.clear
        centerView.center = tabBar.center
        view.addSubview(centerView)
        
        // Upper Curve
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 50, y: 8, width: 100, height: 100), cornerRadius: 50).cgPath
        layer.fillColor = color.statusBarColor.cgColor
        centerView.layer.addSublayer(layer)
        
        // Arrange center button for tabbar
        centerButton.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        centerButton.setBackgroundImage(buttonImage, for: .normal)
        centerButton.setBackgroundImage(highlightImage, for: .normal)
        centerButton.layer.cornerRadius = centerButton.layer.frame.height * 0.5
        centerButton.addTarget(self, action: #selector(MainTabViewController.centerButtonPressed), for: .touchUpInside)
        centerButton.center = CGPoint(x: centerView.frame.width/2, y: ((centerView.frame.height/2) - 10))
        centerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        centerView.addSubview(centerButton)
       
    }
    
    
    func updateButtonForDownloadProgression(count: String) {
        
        self.centerButton.setTitle(count, for: .normal)
    }
    
    // MARK: Events
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // Override second tab click
        if let _ = viewController as? SyncViewController {
            return false
        }

        return true
        
    }
    
    // Middle Button press
    func centerButtonPressed() {
        
        // Selecting second tabitem
        self.selectedIndex = 1
     
    }

}




