//
//  ViewController.swift
//  hasibal
//
//  Created by cscoi045 on 2017. 2. 7..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit
import Photos

//let albumName = "딴드"
class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
 
    
    var imageArray = [UIImage]()
    var imageArray2 = [UIImage]()
    var PHArray = [PHAsset]()
    var albumFound : Bool = false
    var assetCollection2 : PHAssetCollection!
    var fetchResult2 : PHFetchResult<PHAsset>!
    var assetCollectiontest : PHAssetCollection!
    var collectionOrPhoto : Bool!
    


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView?.allowsMultipleSelection = true
       
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        //먼저 부모가 하던 일을 하고
        super.viewWillAppear(animated)
        //나의 일을 하겠다
        grabPhotos()
        self.collectionView?.reloadData()
    }

    func grabPhotos(){
        
        let imgManager = PHImageManager.default()

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
   
//        let fetchOptions2 = PHFetchOptions()
//        fetchOptions2.predicate = NSPredicate(format: "title = %@", albumName)
//        let collection2 : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions2)
//
//        if let first_Obj2:AnyObject = collection2.firstObject {
//            //found the album
//            self.albumFound = true
//            self.assetCollection2 = first_Obj2 as! PHAssetCollection
//            let albumCount = collection2.count
//            print(albumCount)
//
//        }else {
//            //create
//            var albumPlaceholder:PHObjectPlaceholder!
//
//            NSLog("\nFolder \"%@\" does not exist\n creating now..", albumName)
//            PHPhotoLibrary.shared().performChanges({
//                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
//                albumPlaceholder = request.placeholderForCreatedAssetCollection
//            },
//                completionHandler: {(success:Bool, error:Error?)in
//                if(success){
//                print("Successfully created folder")
//                self.albumFound = true
//                 let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
//                 self.assetCollection2 = collection.firstObject! as PHAssetCollection
//  //               self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection2, options: nil)
//                    }else{
//                        print("Error creating folder")
//                            self.albumFound = false
//
//                                                    }
//            })
//
//
//    }

  
        
     

//        let assetCollectionRO = PHFetchOptions()
//        assetCollectionRO.predicate = NSPredicate(format: "title = %@", albumName)
//        
//        let assetcollection : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: assetCollectionRO)
//        print("\(assetcollection.count)")

        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        

        
        if collectionOrPhoto == true {
        if let fetchResult :PHFetchResult = PHAsset.fetchAssets(in: assetCollectiontest , options: fetchOptions) {
        
            if fetchResult.countOfAssets(with: PHAssetMediaType.image) > 0 {
                
                for i in 0..<fetchResult.count{
                    
                    imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions, resultHandler: {image, Error in
                    self.imageArray.append(image!)
                    self.PHArray.append(fetchResult.object(at: i))
//                        print("Succeesssss")
                    })
                    
                }
                
                
                
            }else{print("you got no Photos")
            self.collectionView?.reloadData()
            }
            
            
            
            
        }
        else{print("you got no Photos")
            self.collectionView?.reloadData()}
        }else{
            if let fetchResult :PHFetchResult = PHAsset.fetchAssets(with: .image , options: fetchOptions) {
                
                if fetchResult.countOfAssets(with: PHAssetMediaType.image) > 0 {
                    
                    for i in 0..<fetchResult.count{
                        
                        imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions, resultHandler: {image, Error in
                            self.imageArray.append(image!)
                            self.PHArray.append(fetchResult.object(at: i))
                            //                        print("Succeesssss")
                        })
                        
                    }
                    
                    
                    
                }else{print("you got no Photos")
                    self.collectionView?.reloadData()
                }
                
                
                
                
            }
            else{print("you got no Photos")
                self.collectionView?.reloadData()}
        
        
        
        
        }
    
    
    
    
    }
    
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            //return 10
            return imageArray.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
       cell.imgVu.image = imageArray[indexPath.row]
        //cell.backgroundColor = UIColor.blue
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            
            let width = collectionView.frame.width / 3 - 1
            
            return CGSize(width: width , height: width)
            }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 1.0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1.0
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! as String == "viewLargePhoto" {
            
            let controller : scrollViewController = segue.destination as! scrollViewController
            let indexpath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell)
            controller.index = indexpath!.item
            controller.assetto = PHArray[indexpath!.row]
            controller.imageBoo2 = imageArray[controller.index]
//            controller.photosAsset = self.
            controller.assetCollection = self.assetCollection2
            controller.imageAArray = self.imageArray

        }
    }




}



//extension ViewController: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        
//        guard let changes = changeInstance.changeDetails(for: fetchResult2)
//            else { return }
//        
//        // Change notifications may be made on a background queue. Re-dispatch to the
//        // main queue before acting on the change as we'll be updating the UI.
//        DispatchQueue.main.sync {
//            // Hang on to the new fetch result.
//            fetchResult2 = changes.fetchResultAfterChanges
//            if changes.hasIncrementalChanges {
//                // If we have incremental diffs, animate them in the collection view.
//                guard let collectionView = self.collectionView else { fatalError() }
//                collectionView.performBatchUpdates({
//                    // For indexes to make sense, updates must be in this order:
//                    // delete, insert, reload, move
//                    if let removed = changes.removedIndexes, removed.count > 0 {
//                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
//                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    if let changed = changes.changedIndexes, changed.count > 0 {
//                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    changes.enumerateMoves { fromIndex, toIndex in
//                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
//            } else {
//                // Reload the collection view if incremental diffs are not available.
//                collectionView!.reloadData()
//            }
//        }
//    }
//}
