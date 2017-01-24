//
//  ViewController.swift
//  ModuleTest
//
//  Created by apple on 17/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {

    // MARK: Connection Objects
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Declaration
    let networkHandler = NetworkHandler.sharedInstance
    var feedModal = Feed()
    let parser = FeedParser.sharedInstance
    let apiConnection = ApiConnection.sharedInstance
    let getPostKeys = ApiGetPostKeys.sharedInstance
    let utilityMessages = UtilityMessages.sharedInstance
    let colors = Colors.sharedInstance
    
    let minimumPadding: CGFloat = 20
    let minimumInterSpacing:CGFloat = 20
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureView()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: Arrange View
    func configureView() {
        
        collectionView.backgroundColor = colors.feedPageBackground
        
    }
    
    
    // Loda Data from sever
    func loadData() {
       
        let params = [getPostKeys.lang: "0"]
        networkHandler.post(apiConnection.feeds, params: params) { (networkStatus, response) in
            
            if !networkStatus {
                self.showMessage(self.utilityMessages.noConnection)
                return
            }
            
            // Expect a dictionary modal from server
            if let _response = response as? Dictionary<String, Any> {
                self.parser.parse(response: _response, modal: &self.feedModal, completionHandler: {
                  
                    // Update UI
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                })
            }
        }
        
    }
    
    
    // Show user alerts
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Warning!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}


// MARK: Collection View
extension FeedsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if feedModal.feeds.isEmpty {
            return 1
        }
        return feedModal.feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if feedModal.feeds.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.imageView.image = UIImage(named: "empty_icon")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedsViewCell", for: indexPath) as! FeedsViewCell
        cell.feed = feedModal.feeds[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height - minimumPadding - minimumPadding
        let width = view.frame.width - minimumPadding - minimumPadding
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterSpacing
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: minimumPadding, left: minimumPadding, bottom: minimumPadding, right: minimumPadding)
    }
    
    
}












