//
//  BaseTableViewCell.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 18.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var post: Post? {
        didSet {
            loadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadImage() {
        if let url = NSURL(string: (post?.img)!) {
            
            postImageView.image = nil
            
            if let img = imageCache[post!.img] {
                postImageView.image = img
                post!.image = img
            } else {
                let request: NSURLRequest = NSURLRequest(URL: url)
                let mainQuene = NSOperationQueue.mainQueue()
                
                activityIndicatorView.startAnimating()
                
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQuene, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        
                        self.activityIndicatorView.stopAnimating()
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let image = UIImage(data: data!)
                            
                            imageCache[self.post!.img] = image
                            
                            self.postImageView.image = image
                            self.post!.image = image
                            self.activityIndicatorView.stopAnimating()
                        })
                    }
                })
            }
        }
    }
}
