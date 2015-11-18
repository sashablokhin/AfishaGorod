//
//  MainTableViewController.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 17.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class MainTableViewController: UITableViewController {

    let baseUrlString = "http://gorod.afisha.ru"
    
    var posts = [Post]()
    
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
                
                if error == nil {
                    
                    let content = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    let contentArray: NSArray = content.componentsSeparatedByString("<article class=") as NSArray!
                    
                    if contentArray.count > 1 {
                        for i in 1..<contentArray.count {
                            self.parseArticle(contentArray[i] as! String)
                        }
                    }
                    
                }
            })
            
            task.resume()
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
                let datetime = article.valueForTag("datetime=\"", close: "</time>")
                let fullDateTime = datetime.componentsSeparatedByString("\">").first!
                let shortDateTime = datetime.componentsSeparatedByString("\">").last!
                
                let post = Post(article: Article.Super, link: link, title: title, img: img, theme: theme, views: views, comments: comments, tag: tag, datetime: datetime, fullDateTime: fullDateTime, shortDateTime: shortDateTime)
                
                posts.append(post)
                /*
                print(link)
                print(title)
                print(img)
                print(theme)
                print(views)
                print(comments)
                print(tag)
                print(fullDateTime)
                print(shortDateTime)
                print("\n")*/
                
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
                
                let post = Post(article: Article.Item, link: link, title: title, img: img, theme: theme, views: views, comments: comments, tag: tag, datetime: datetime, fullDateTime: fullDateTime, shortDateTime: shortDateTime)
                
                posts.append(post)
                
                /*
                print(link)
                print(title)
                print(img)
                print(tag)
                print(fullDateTime)
                print(shortDateTime)
                print(theme)
                print(views)
                print(comments)
                print("\n")*/
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if posts[indexPath.row].article == Article.Super {
            return 200
        } else if posts[indexPath.row].article == Article.Item {
            return 170
        }
        
        return 200
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if posts[indexPath.row].article == Article.Super {
            let cell = tableView.dequeueReusableCellWithIdentifier("superCell") as! SuperTableViewCell

            cell.post = posts[indexPath.row]
            
            return cell
        } else if posts[indexPath.row].article == Article.Item {
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! ItemTableViewCell
            
            cell.post = posts[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let visibleCells = tableView.visibleCells as? [BaseTableViewCell] {
            for parallaxCell in visibleCells {
                
                if parallaxCell.post?.article == Article.Super {
                    let yOffset = ((tableView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
                    parallaxCell.offset(CGPointMake(0.0, yOffset))
                }
            }
        }
    }

}
