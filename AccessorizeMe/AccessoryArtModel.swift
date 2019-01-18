//
//  AccessoryArtModel.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/17/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit
class AccessoryArtModel {
    
    
    var imagesNamesFromFolder: [String]?
    
    init(){
        loadImagesFromFolder()
        
    }
    
    func loadImagesFromFolder() {
        let fm = FileManager.default
        let path = Bundle.main.bundlePath
        imagesNamesFromFolder = try? fm.contentsOfDirectory(atPath: path + "/Accessory Images" + "/Sunglasses")
        imagesNamesFromFolder = imagesNamesFromFolder?.filter({ $0.hasSuffix(".png")
        })
    }
}
