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
    
    
    @IBOutlet var containerView: UIView!

    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var filterScrollView: UIScrollView!
    
    
 
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
                    if let assetCollection = self.assetCollection {
                        let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                        addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
                    }
                }, completionHandler: {success, error in
                    if !success { print("error creating asset: \(error)") }
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
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 3
        
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(scrollViewController.filterButtonTapped(_:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 4
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
        filterScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+2), height: yCoord)
        
        
    }

    
    func filterButtonTapped(_ sender: UIButton) {
        let button = sender as UIButton
        
        imageToFilter.image = button.backgroundImage(for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

