//
//  AccessoryCollectionViewCell.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/10/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accessoryImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

