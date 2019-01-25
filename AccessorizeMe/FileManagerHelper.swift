//
//  FileManager.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/21/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit
class FileManagerHelper {
    /**
     # Get Contents From Folder
        The static function is used by multiple classes to retrieve the directory thats passed in.
     - Parameters:
        - folderPath
        The path of the accessory images.
 */
    static func getContentsFromFolder(from folderPath: String) -> [String]? {
        let fileManager = FileManager.default
        var path = Bundle.main.bundlePath
        var folderNamesFromFileManager = try? fileManager.contentsOfDirectory(atPath: path + folderPath)
        
        return folderNamesFromFileManager
    }
}
