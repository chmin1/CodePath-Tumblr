//
//  photoDetailViewController.swift
//  CodePath-Tumblr
//
//  Created by Chavane Minto on 11/18/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit
import AlamofireImage

class photoDetailViewController: UIViewController {
    
    @IBOutlet weak var tumblrImage: UIImageView!
    
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tumblrImage.af_setImage(withURL: imageURL)
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
