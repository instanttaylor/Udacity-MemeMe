//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/28/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    var meme: Meme?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
