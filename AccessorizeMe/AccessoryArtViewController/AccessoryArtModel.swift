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
    var imagesFolder = "/Masks"
    init(){
        loadImagesFromFolder(in: imagesFolder)
        
    }
    
    func loadImagesFromFolder(in subpath: String) {
        imagesNamesFromFolder = FileManagerHelper.getContentsFromFolder(from: "/Accessory Images" + subpath)
        imagesNamesFromFolder = imagesNamesFromFolder?.filter({ $0.hasSuffix(".png")
        })
    }
}
