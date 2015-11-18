//
//  BaseTableViewCell.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 18.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

let ImageHeight: CGFloat = 240.0
let OffsetSpeed: CGFloat = 25.0

class BaseTableViewCell: UITableViewCell {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    
    var post: Post? {
        didSet {
            titleLabel.text = post!.title
            
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
                activityIndicatorView.startAnimating()
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        
                        let image = UIImage(data: data!)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.activityIndicatorView.stopAnimating()
                            
                            imageCache[self.post!.img] = image
                            
                            self.postImageView.image = image
                            self.post!.image = image
                        })
                    }
                })
                
                task.resume()
            }
        }
    }
    
    func offset(offset: CGPoint) {
        postImageView.frame = CGRectOffset(self.postImageView.bounds, offset.x, offset.y)
    }
}





























