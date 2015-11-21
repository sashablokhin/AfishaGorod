//
//  PostDetailViewController.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 21.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    var post: Post?
    
    var imageYPos: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImageView.image = post?.image
    }
    
    override func viewDidLayoutSubviews() {
        contentView.transform = CGAffineTransformMakeTranslation(0, postImageView.frame.height)
        
        imageYPos = postImageView.frame.origin.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollOffset: CGFloat = scrollView.contentOffset.y
        let newScale: CGFloat = 1 + (scrollOffset * -1) / 230.0
        
        if scrollOffset < 0 {
            if newScale > 1.0 || newScale < 2.0 {
                self.postImageView.transform = CGAffineTransformMakeScale(newScale, newScale)
                self.postImageView.frame.origin.y = imageYPos
            }
        }
        else if (scrollOffset > 0.0)
        {
            self.postImageView.frame.origin.y = (scrollOffset / 4.0) * -1 + imageYPos
        }
        else if (scrollOffset == 0.0)
        {
            self.postImageView.transform = CGAffineTransformIdentity;
            self.postImageView.frame.origin.y = imageYPos
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
