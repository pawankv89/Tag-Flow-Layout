//
//  TagCell.swift
//  Tag Flow Layout
//
//  Created by Pawan kumar on 14/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        //Must Number of Line set 1 always when use iOS Version 10.0 and Above
        self.tagName.numberOfLines = 1
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }

}
