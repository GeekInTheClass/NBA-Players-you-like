//
//  AlbumviewTableViewController.swift
//  daaend
//
//  Created by cscoi045 on 2017. 2. 13..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit
import Photos


let albumName = "딴드"

class tbviewCell : UITableViewCell {
    

    @IBOutlet weak var allPhotoView: UIImageView!
    @IBOutlet weak var allPhotolabel1: UILabel!

    
    @IBOutlet weak var collectionView: UIImageView!
    @IBOutlet weak var collectionViewlabel1: UILabel!
 
    
    
    @IBOutlet weak var newLabel: UILabel!
    
    
}



class AlbumviewTableViewController: UITableViewController {
    
    
    func testerDownloader ()->() {
    
    }
    
    
    
    enum CellIdentifier: String {
        case allPhotos, collection
    }
 
    
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
    enum SegueIdentifier: String {
        case showAllPhotos
        case showCollection
    }

    var albumResult : PHFetchResult<PHAssetCollection>!
    var allPhotos : PHFetchResult<PHAsset>!
    var collection : PHAssetCollection!
    var albumFound : Bool = false
    var albumArray : [PHAssetCollection] = []
    var userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    var smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)

    
    func grabNewAlbum ()->() {

//        let AlbumManager = PHImageManager.default()
        
        let fetchOptions2 = PHFetchOptions()
        fetchOptions2.predicate = NSPredicate(format: "title = %@", albumName)
        let collection2 : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions2)
        

        
        
        if let first_Obj2:AnyObject = collection2.firstObject {
            //found the album
            self.albumFound = true
            self.collection = first_Obj2 as! PHAssetCollection
            
            
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
                                                        self.collection = collection.firstObject! as PHAssetCollection
                                                        //               self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection2, options: nil)
                                                    }else{
                                                        print("Error creating folder")
                                                        self.albumFound = false
                                                        self.reloadInputViews()
                                                    }
            })
            
            
        }
    
    }
    func putPhotos(PHfetchResul: PHAsset)->(UIImage){
        let imigiManager = PHImageManager.default()
        let requestOptions2 = PHImageRequestOptions()
        requestOptions2.isSynchronous = true
        requestOptions2.deliveryMode = .highQualityFormat
        var image2 : UIImage!

    imigiManager.requestImage(for: PHfetchResul , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions2, resultHandler: {image, Error in
    
        image2 = image
                          
    })
        return image2
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        grabNewAlbum()
        PHPhotoLibrary.shared().register(self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        print(allPhotos.count)
 
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination  as? ViewController
            else { fatalError("unexpected view controller for segue") }
        let cell = sender as! tbviewCell
        
        
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .showAllPhotos:
            destination.fetchResult2 = allPhotos
            destination.collectionOrPhoto = false
            destination.title = cell.allPhotolabel1.text

        case .showCollection:
            
            // get the asset collection for the selected row
            let indexPath = tableView.indexPath(for: cell)!
            let collection: PHCollection
            switch Section(rawValue: indexPath.section)! {
            case .smartAlbums:
                collection = smartAlbums.object(at: indexPath.row)
            case .userCollections:
                collection = userCollections.object(at: indexPath.row)
            default: return // not reached; all photos section already handled by other segue
            }
            
            // configure the view controller with the asset collection
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("expected asset collection") }
            destination.fetchResult2 = PHAsset.fetchAssets(in: assetCollection, options: nil)
            destination.assetCollectiontest = assetCollection
            destination.collectionOrPhoto = true
            destination.title = cell.collectionViewlabel1.text
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.allPhotos.rawValue, for: indexPath) as! tbviewCell
            cell.allPhotolabel1.text = "All Photos"


            if allPhotos.firstObject != nil
            {cell.allPhotoView.image = putPhotos(PHfetchResul: allPhotos.firstObject!)} else{cell.allPhotoView.image = UIImage(named: "noPhoto")}
                return cell
            
        case .smartAlbums:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath) as! tbviewCell
            let collection = smartAlbums.object(at: indexPath.row)
            cell.collectionViewlabel1.text = collection.localizedTitle

            let fetchOptions4 = PHFetchOptions()
            fetchOptions4.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            fetchOptions4.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let smtfetchAsset = PHAsset.fetchAssets(in: collection, options: fetchOptions4)
            if smtfetchAsset.firstObject != nil {cell.collectionView.image = putPhotos(PHfetchResul: smtfetchAsset.firstObject!)}
            else {cell.collectionView.image = UIImage(named: "noPhoto")}
            
            cell.newLabel.textColor = UIColor.red
            cell.newLabel.font.withSize(10)
            cell.newLabel.text = ""
            return cell
            
        case .userCollections:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath) as! tbviewCell
            let collection = userCollections.object(at: indexPath.row)
            cell.collectionViewlabel1.text = collection.localizedTitle
            
            
            let fetchOptions5 = PHFetchOptions()
            fetchOptions5.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            fetchOptions5.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let smtfetchAsset = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: fetchOptions5)
            if smtfetchAsset.firstObject != nil {cell.collectionView.image = putPhotos(PHfetchResul: smtfetchAsset.firstObject!)}
            else {cell.collectionView.image = UIImage(named: "noPhoto")}
            
            
            cell.newLabel.textColor = UIColor.red
            cell.newLabel.font.withSize(10)
            cell.newLabel.text = ""
            
            
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .allPhotos: return "All Photos"
        case .smartAlbums: return "Smart Album"
        case .userCollections: return "Album"
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}







extension AlbumviewTableViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                
                }
                // (The table row for this one doesn't need updating, it always says "All Photos".)
            }
            
            // Update the cached fetch results, and reload the table sections to match.
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
                    
                }
     
               
    
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
                if changeDetails.hasIncrementalChanges{
                 let Cell2 = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue) as! tbviewCell
                    
           
                
            }
            
        }
}



}
