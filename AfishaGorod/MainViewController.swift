//
//  ViewController.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 10.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    let baseUrlString = "http://gorod.afisha.ru"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "gorod2")
        
        navigationItem.titleView = imageView
    
        let menuButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        menuButton.setImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        
        let okButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        okButton.setImage(UIImage(named: "ok.png"), forState: UIControlState.Normal)
        //okButton.addTarget(self, action: "commitSelection", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okButton)
        
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        
        revealViewController().rearViewRevealWidth = 130
        
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func request() {
        let url = NSURL(string: baseUrlString)
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                //var urlError = false
                
                if error == nil {
                    
                    let content = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    let contentArray: NSArray = content.componentsSeparatedByString("<article class=") as NSArray!
                    
                    if contentArray.count > 1 {
                        for i in 1..<contentArray.count {
                            self.parseArticle(contentArray[i] as! String)
                        }
                    } else {
                        //urlError = true
                    }
                    
                } else {
                    //urlError = true
                }
            })
            
            task.resume()
            
        } else {
            //showError()
        }
    }
    
    
    func parseArticle(var article: String) {
        if article.containsString("articles_item") {
            if article.containsString("articles_super") {
                
                let link = article.valueForTag("<a href=\"", close: "\"")
                let title = article.valueForTag("title=\"", close: "\"")
                let img = article.valueForTag("data-src1=\"", close: "\"")
                let theme = article.valueForTag("article_theme\">", close: "</span>")
                let views = article.valueForTag("article-info_views\">", close: "</span>")
                let comments = article.valueForTag("article-info_comments\">", close: "</span>")
                let tag = article.valueForTag("title=\"", close: "\"")
                let datetime = article.valueForTag("datetime=\"", close: "</time>")//.componentsSeparatedByString("\">").last
                let fullDateTime = datetime.componentsSeparatedByString("\">").first!
                let shortDateTime = datetime.componentsSeparatedByString("\">").last!
                
                print(link)
                print(title)
                print(img)
                print(theme)
                print(views)
                print(comments)
                print(tag)
                print(fullDateTime)
                print(shortDateTime)
                print("\n")
                
            } else {
                let link = article.valueForTag("<a href=\"", close: "\"")
                let img = article.valueForTag("<img src=\"", close: "\"")
                let tag = article.valueForTag("class=\"tag", close: "<").componentsSeparatedByString(">").last!
                let datetime = article.valueForTag("datetime=\"", close: "</time>")
                let fullDateTime = datetime.componentsSeparatedByString("\">").first!
                let shortDateTime = datetime.componentsSeparatedByString("\">").last!
                let title = article.valueForTag("title=\"", close: "\">")
                let theme = article.substringToIndex((article.rangeOfString("<span")?.startIndex)!)
                let views = article.valueForTag("article-info_views\">", close: "</span>")
                let comments = article.valueForTag("article-info_comments\">", close: "</span>")
                
                print(link)
                print(title)
                print(img)
                print(tag)
                print(fullDateTime)
                print(shortDateTime)
                print(theme)
                print(views)
                print(comments)
                print("\n")
            }
        }
    }
}

extension String {
    mutating func valueForTag(tag: String, close: String) -> String {
        let start = self.rangeOfString(tag)?.endIndex
        
        self = self.substringFromIndex(start!)
        
        let startClose = self.rangeOfString(close)?.startIndex
        let endClose = self.rangeOfString(close)?.endIndex
        
        let value = self.substringToIndex(startClose!)
        
        self = self.substringFromIndex(endClose!)
        
        return value
    }
}
























