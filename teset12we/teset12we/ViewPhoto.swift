//
//  ViewPhoto.swift
//  teset12we
//
//  Created by cscoi045 on 2017. 2. 3..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit
import Photos

class ViewPhoto: UIViewController {

    var assetCollection : PHAssetCollection!
    var photosAsset : PHFetchResult<PHAsset>!
    var index : Int = 0
    
    
    @IBAction func btnCancel(_ sender: Any) {
        print("Cancel")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnExport(_ sender: Any) {
        print("Export")
    }
    @IBAction func btnTrash(_ sender: Any) {
        print("Trash")
    }
    @IBOutlet weak var imgView: UIImageView!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        self.displayPhoto()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayPhoto(){
        let imageManager = PHImageManager.default()
        var ID = imageManager.requestImage(for: self.photosAsset[self.index], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil, resultHandler: {(result:UIImage!, info:[AnyHashable: Any]?) in
            self.imgView.image = result} as! (UIImage?, [AnyHashable : Any]?) -> Void)
    }

}
