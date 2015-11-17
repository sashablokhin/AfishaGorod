//
//  Extensions.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 16.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import Foundation

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