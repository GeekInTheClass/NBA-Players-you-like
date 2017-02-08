//
//  PhotoThumbnail.swift
//  teset12we
//
//  Created by cscoi045 on 2017. 2. 4..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!

    func setThumbnailImage(thumbnailImage : UIImage){
    self.imgView.image = thumbnailImage
    }
        
    
    
}
