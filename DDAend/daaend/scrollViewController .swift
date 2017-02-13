//
//  ViewController.swift
//  multifilter
//
//  Created by cscoi044 on 2017. 2. 8..
//  Copyright © 2017년 takeawalk. All rights reserved.
//

import UIKit
import Photos

class scrollViewController : UIViewController {

    var assetCollection : PHAssetCollection! 
    var photosAsset : PHFetchResult<PHAsset>!
    var index : Int = 0
    var imageBoo2 : UIImage!
    var assetto : PHAsset!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var imageAArray : [UIImage]!
    
    @IBOutlet var containerView: UIView!

    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBAction func cancel(_ sender: UINavigationItem) {
       self.navigationController?.popToRootViewController(animated: true)
        reloadInputViews()
  
        
    }
    
    
 
    @IBAction func save(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: NSLocalizedString("New Photo", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Photos Name", comment: "")
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .default) { action in
            let textField = alertController.textFields!.first!
            if let title = textField.text, !title.isEmpty {
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: (self.imageToFilter?.image)!)

                    let fetchOption6 = PHFetchOptions()
                    fetchOption6.predicate = NSPredicate(format: "title = %@", "딴드")
                    let collection2 : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOption6)
  
                    if let assetCollection = collection2.firstObject {
                        let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                        addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
                    }
                }, completionHandler: {success, error in
                    if !success { print("error creating asset: \(error)")
                    
                    }
                
                })
            }
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                                style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)

    
    
      
    }
    
    
     var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        originalImage.image =  imageBoo2
        if originalImage.image == nil {print("shit")}
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    
       /* func showActivityIndicatory(uiView: UIView) { */
            //var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x: self.filterScrollView.center.x, y: self.filterScrollView.center.y, width: 40.0, height: 40.0);
          actInd.center = self.filterScrollView.center
            actInd.hidesWhenStopped = true
            actInd.activityIndicatorViewStyle =
                UIActivityIndicatorViewStyle.gray
            view.addSubview(actInd)
            actInd.startAnimating()
       /* }*/
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var itemCount = 0
        var xCoord: CGFloat = 3
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 3

        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(scrollViewController.filterButtonTapped(_:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // CODE FOR FILTERS WILL BE ADDED HERE...
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            guard let coreImage = CIImage(image: originalImage.image!) else{return print("sths Wrong")}
            let filter = CIFilter(name: "\(CIFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!);
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            filterScrollView.addSubview(filterButton)
            
        } // END FOR LOOP
        
        // Resize Scroll View
        filterScrollView.contentSize = CGSize(width: 1 * CGFloat(73*8+3), height: yCoord)
        
        actInd.stopAnimating()

        
    }
    
    func filterButtonTapped(_ sender: UIButton) {
        let button = sender as UIButton
        
        imageToFilter.image = button.backgroundImage(for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sharebutton(_ sender: Any) {
        
        let activityItem: [AnyObject] = [self.imageToFilter?.image as AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
        
        /*
        // image to share
        let image = UIImage(named: "image")
        /*PHAssetChangeRequest.creationRequestForAsset(from: (self.imageToFilter?.image)!)*/
        // set up activity view controller
        
         //let imageToShare = [ image ]
         //let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        let activity = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        
        // exclude some activity types from the list (optional)
        // activity.excludedActivityTypes = [ UIActivityType.saveToCameraRoll ]
        
        // present the view controller
         //self.present(activityViewController, animated: true, completion: nil)
        present(activity, animated: true, completion: nil)
*/
    
    
    }


}

