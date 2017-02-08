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
    var photosAsset : PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize!
    //action and outlet
    
    @IBAction func btnCamera(_ sender: Any) {
    }
    @IBAction func btnPhotoAlbum(_ sender: Any) {
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // goal: check if the folder exists, if it does not , create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let first_Obj:AnyObject = collection.firstObject {
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
            
        }else {
        //create
        var albumPlaceholder:PHObjectPlaceholder!
        
        NSLog("\nFolder \"%@\" does not exist\n creating now..", albumName)
        PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
            completionHandler: {(success:Bool, error:Error?)in
                if(success){
                    print("Successfully created folder")
                    self.albumFound = true
                    let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    self.assetCollection = collection.firstObject! as PHAssetCollection
                    
                    self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    
                    self.collectionView.reloadData()
                    
                }else{
                    print("Error creating folder")
                    self.albumFound = false
                }
            })


//            {(success:Bool, error:NSError!)in
//                NSLog("creation of folder --> %@", (success ? true : false)}
//                self.albumFound = (success ? true : false)
//            }
       
    }
}
    
    
    override func viewWillAppear(_ animated: Bool) {
        //fetch the photos from the collection
        self.navigationController?.hidesBarsOnTap = false
        //네비게이션 바가 사라지지않도록 하는 예방방법이다
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        
        

        //url임에셋이 아마도
        
        //handle no photos i the assetcollection
        //..have a label tha tsays "No Photos"
        self.collectionView.reloadData()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! as String == "viewLargePhoto" {
            let controller: ViewPhoto = segue.destination as! ViewPhoto
            let indexPath  = self.collectionView.indexPath(for: sender as! UICollectionViewCell)
            controller.index = indexPath!.item
            controller.photosAsset = self.photosAsset
            controller.assetCollection = self.assetCollection
            }
        
        
    }
    

    
    
    
    //uicollectionview  Data source methods ctrl누르고 컬렉션 뷰 컨트롤러 데이터 소스 클릭하여 만드는것
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if self.photosAsset != nil{
            count = self.photosAsset.count
        }
        return count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : PhotoThumbnail = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as! PhotoThumbnail
        
    
    //implement class for uiimage
        let asset : PHAsset = self.photosAsset[indexPath.item] as! PHAsset

        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info)in
            if let image = result {
                cell.setThumbnailImage(thumbnailImage: image)
            }
        })
        return cell
    }



}

