//
//  MediaStorageController+Config.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import Foundation

public extension MediaStorageController {
    
    struct Configuration {
        var fileManager: FileManager
        var baseDocumentsDirectory: URL?
        var baseCacheDirectory: URL?
        
        public init(fileManager: FileManager = .default, baseDocumentsDirectory: URL? = nil, baseCacheDirectory: URL? = nil) {
            self.fileManager = fileManager
            self.baseDocumentsDirectory = baseDocumentsDirectory
            self.baseCacheDirectory = baseCacheDirectory
        }
    }
    
}
