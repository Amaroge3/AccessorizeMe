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
    
    static func getContentsFromFolder(from folderPath: String) -> [String]? {
        let fileManager = FileManager.default
        let path = Bundle.main.bundlePath
        let folderNamesFromFileManager = try? fileManager.contentsOfDirectory(atPath: path + folderPath)
        
        return folderNamesFromFileManager
    }
}
