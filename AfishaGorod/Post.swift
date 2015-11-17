//
//  Post.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 16.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import Foundation

enum Article {
    case Item
    case Super
}

class Post {
    var article: Article
    var link: String
    var title: String
    var img: String
    var theme: String
    var views: String
    var comments: String
    var tag: String
    var datetime: String
    var fullDateTime: String
    var shortDateTime: String
    
    var image: UIImage?
    
    init (article: Article, link: String, title: String, img: String, theme: String, views: String, comments: String, tag: String, datetime: String, fullDateTime: String, shortDateTime: String) {
    
        self.article = article
        self.link = link
        self.title = title
        self.img = img
        self.theme = theme
        self.views = views
        self.comments = comments
        self.tag = tag
        self.datetime = datetime
        self.fullDateTime = fullDateTime
        self.shortDateTime = shortDateTime
    }
}
