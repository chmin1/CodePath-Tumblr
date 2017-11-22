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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
        let post = posts[section];
        if let date = post["date"] as? String {
            dateLabel.text = date;
        }
        
        headerView.addSubview(dateLabel);
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tumblrView.dequeueReusableCell(withIdentifier: "tumblrCell", for: indexPath) as! TumblrCell;
        
        let post = posts[indexPath.section];
        
        if let photos = post["photos"] as? [[String:Any]] {
            let photo = photos[0];
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            cell.tumblrImage.af_setImage(withURL: url!)
        }
        
        
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! photoDetailViewController;
        
        let cell = sender as! UITableViewCell;
        
        let indexPath = tumblrView.indexPath(for: cell)!;
        
        let post = posts[indexPath.section];
        let photos = post["photos"] as! [[String:Any]];
        let photo = photos[0];
        let originalSize = photo["original_size"] as! [String: Any];
        let urlString = originalSize["url"] as! String;
        
        destVC.imageURL = URL(string: urlString);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
