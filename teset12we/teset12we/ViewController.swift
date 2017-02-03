//
//  ViewController.swift
//  teset12we
//
//  Created by cscoi045 on 2017. 2. 3..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit

import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "My App"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var albumFound : Bool = false
    var assetCollection : PHAssetCollection!
    var photosAsset : PHFetchResult<AnyObject>!
    
    
    
    
    
    
    //action and outlet
    
    @IBAction func btnCamera(_ sender: Any) {
    }
    @IBAction func btnPhotoAlbum(_ sender: Any) {
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // goal: check if the folder exists, if it does not , create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
    
        
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if collection.firstObject != nil {
            //found the album
            self.albumFound = true
            self.assetCollection = collection.firstObject! as PHAssetCollection
            
        }else {
        //create
        NSLog("\nFolder \"%@\" does not exist\n creating now..", albumName)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)

            },
            completionHandler: nil)
//            {(success:Bool, error:NSError!)in
//                NSLog("creation of folder --> %@", (success ? true : false))
//                self.albumFound = (success ? true : false)
//            }
       
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //uicollectionview 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return 1
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as UICollectionViewCell
    
    cell.backgroundColor = UIColor.red
        
    return cell
    }



}

