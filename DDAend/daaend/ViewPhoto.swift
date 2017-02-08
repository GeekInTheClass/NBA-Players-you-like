//
//  ViewPhoto.swift
//  hasibal
//
//  Created by cscoi045 on 2017. 2. 7..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit
import Photos

class ViewPhoto: UIViewController {

    var assetCollection : PHAssetCollection!
    var photosAsset : PHFetchResult<PHAsset>!
    var index : Int = 0
    var imageBoo : UIImage!
    

    @IBOutlet weak var bigPhoto: UIImageView!

    @IBAction func applyFilter(_ sender: Any) {
        guard let image = self.bigPhoto.image?.cgImage else { return }
        //이게 뭐냐면 가드렛안되면 그냥 브레이크하는것임
        // nil 이 아니면 다음 문단으로 넘어가라
        // ui 가 아니라 cgimage로 불러왔다
        
        let openGLContext = EAGLContext(api: .openGLES3)
        // open geo context // gpu에 접근하는 것. 필터 매우 복잡한 작업이기 때문에
        let context = CIContext(eaglContext: openGLContext!)
        // open image context // core image와 gpu를 잇는 conjunction
        
        let ciImage = CIImage(cgImage: image)
        // create a core image
        let filter = CIFilter(name: "CISepiaTone")
        // create a filter : we want to use
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey) // 필터가 적용될 이미지로 ciimage를 넣어라
        filter?.setValue(1, forKey: kCIInputIntensityKey) // 필터의 적용 강도를 1로 정해라
        
        
        /* if let sepiaOutput = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
         let exposureFilter = CIFilter(name: "CIExposureAdjust")
         exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
         exposureFilter?.setValue(1, forKey: kCIInputEVKey) */
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage{
            self.bigPhoto?.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigPhoto.image = imageBoo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
