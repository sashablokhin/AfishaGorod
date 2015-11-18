//
//  ItemTableViewCell.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 16.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

class ItemTableViewCell: BaseTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.postImageView.layer.cornerRadius = self.postImageView.frame.size.width / 2;
        self.postImageView.clipsToBounds = true;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

