//
//  LoadingView.swift
//  DES
//
//  Created by Sarath on 26/11/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    let loadingImage = UIImage(named: "loading")
    var loadingImageView: UIImageView
    
    /// Custom container view
    open dynamic var containerView: UIView?
    
    fileprivate static let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 480)
    
    
    public required init?(coder aDecoder: NSCoder) {
        loadingImageView = UIImageView(image: loadingImage)
        super.init(coder: aDecoder)!
        configure()
    }
    
    public override init(frame: CGRect) {
        loadingImageView = UIImageView(image: loadingImage)
        super.init(frame: LoadingView.defaultFrame)
        configure()
    }
    
    public init() {
        loadingImageView = UIImageView(image: loadingImage)
        super.init(frame: LoadingView.defaultFrame)
        configure()
    }
    
    
    func configure() {
        
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        loadingImageView = UIImageView(image: loadingImage)
        addSubview(loadingImageView)
        adjustSizeOfLoadingIndicator()
        
    }
    
    func showLoadingIndicator(forView parentView: UIView? = nil) {
        
        loadingImageView.isHidden = false
        self.bringSubview(toFront: loadingImageView)
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Get super view to show
        if let superView = parentView {
            superView.addSubview(self)
            superView.addSubviewWithConstraint(self)
            
        }
        else if let superView = containerView ?? UIApplication.shared.keyWindow {
            superView.addSubview(self)
            superView.addSubviewWithConstraint(self)
        }
        
        
        startRefreshing()
        
    }
    
    func hideLoadingIndicator() {
        
        loadingImageView.isHidden = true
        stopRefreshing()
        self.removeFromSuperview()
    }
    
    
    // MARK: private methods
    // Adjust the size so that the indicator is always in the middle of the screen
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    private func adjustSizeOfLoadingIndicator() {
        
        let loadingImageSize = loadingImage?.size
        loadingImageView.frame = CGRect(x: frame.width/2 - loadingImageSize!.width/2, y: 180, width: loadingImageSize!.width, height: loadingImageSize!.height)
    }
    
    // Start the rotating animation
    private func startRefreshing() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.isRemovedOnCompletion = false
        animation.toValue = M_PI * 2.0
        animation.duration = 0.8
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        loadingImageView.layer.add(animation, forKey: "rotationAnimation")
        
    }
    
    // Stop the rotating animation
    private func stopRefreshing() {
        loadingImageView.layer.removeAllAnimations()
    }
    
}
