//
//  photosViewController.swift
//  CodePath-Tumblr
//
//  Created by Chavane Minto on 11/17/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import UIKit
import AlamofireImage

class photosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tumblrView: UITableView!
    
    var posts: [[String: Any]] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tumblrView.delegate = self;
        tumblrView.dataSource = self;
        
        tumblrView.rowHeight = 320.0
        
        //CREATE A URL REQUEST!!
        //STEP 1:
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!;
        //STEP 2:
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData;
        //STEP 3:
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any];
                let responseDict = dataDict["response"] as! [String:Any];
                self.posts = responseDict["posts"] as! [[String:Any]];
                self.tumblrView.reloadData()
            }
        }
        task.resume();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tumblrView.dequeueReusableCell(withIdentifier: "tumblrCell", for: indexPath) as! TumblrCell;
        
        let post = posts[indexPath.row];
        
        if let photos = post["photos"] as? [[String:Any]] {
            let photo = photos[0];
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            cell.tumblrImage.af_setImage(withURL: url!)
        }
        
        
        return cell;
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
