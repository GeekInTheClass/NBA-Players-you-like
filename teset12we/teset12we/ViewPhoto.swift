//
//  ViewPhoto.swift
//  teset12we
//
//  Created by cscoi045 on 2017. 2. 3..
//  Copyright © 2017년 test. All rights reserved.
//

import UIKit

class ViewPhoto: UIViewController {

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
