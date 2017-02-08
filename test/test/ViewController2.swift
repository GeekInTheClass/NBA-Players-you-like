//
//  ViewController2.swift
//  test
//
//  Created by cscoi045 on 2017. 2. 2..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit


class ViewController2: UIViewController {

    @IBOutlet weak var myImageView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //encoding

        
        let image = UIImage(named : "daT.png")
        let imageData:NSData = UIImagePNGRepresentation(image!)! as NSData
        
        //saved image
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        
        //decoding
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        
        myImageView2.image = UIImage(data : data as Data)
        
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
