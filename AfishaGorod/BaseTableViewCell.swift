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
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    
    var post: Post? {
        didSet {
            let attributedString = NSMutableAttributedString(string: post!.theme + (post!.theme != "" ? "\n" : "") +  post!.title)
            
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, post!.theme.characters.count))
            
            var color = UIColor.whiteColor()

            if post!.article == Article.Item {
                color = UIColor.blackColor()
            }
            
            attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(post!.theme.characters.count, post!.title.characters.count))
            
            titleLabel.attributedText = attributedString
            
            tagLabel.text = post!.tag + "  "
            viewsLabel.text = post!.views
            dateLabel.text = post!.shortDateTime
            commentsLabel.text = post!.comments
            
            tagLabel.layer.cornerRadius = 2;
            tagLabel.clipsToBounds = true;
            
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





























