//
//  AccessoryArtView.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/10/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryArtView: UIView {
    var backgroundImage: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    

}
