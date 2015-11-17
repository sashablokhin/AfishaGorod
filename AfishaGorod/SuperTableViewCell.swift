//
//  SuperTableViewCell.swift
//  AfishaGorod
//
//  Created by Alexander Blokhin on 16.11.15.
//  Copyright © 2015 Alexander Blokhin. All rights reserved.
//

import UIKit

class SuperTableViewCell: UITableViewCell {

    @IBOutlet var postImageView: UIImageView!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
