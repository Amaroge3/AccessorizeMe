//
//  AccessoryTableViewModel.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/21/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit

struct AccessoryTableViewModel {
    // Directory of the accessory images  
    public var accessoryDirectories: [String]?
    // The name of the directory where the images are located
    var imagesDirectoryName = "/Accessory Images"
    
    init() {
        getDirectoriesFromBundlePath()
    }
    /**
     Gets the directory names from the file manager to use in the Table View.
 */
    public mutating func getDirectoriesFromBundlePath() {
        let filemanager = FileManager.default
        let path = Bundle.main.bundlePath
        accessoryDirectories = try? filemanager.contentsOfDirectory(atPath: path + imagesDirectoryName)
    }

}
