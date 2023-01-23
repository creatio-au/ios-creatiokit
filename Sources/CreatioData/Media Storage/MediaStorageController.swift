//
//  MediaStorageController.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import Foundation

public class MediaStorageController {
    
    public enum StorageLevel {
        case documents, cache
    }
    
    private var fileManager: FileManager
    private var cacheDirectory: URL
    private var documentsDirectory: URL
    
    public init(configuration: Configuration = .init()) throws {
        self.fileManager = configuration.fileManager
        
        if let directory = configuration.baseCacheDirectory {
            self.cacheDirectory = directory
        } else {
            self.cacheDirectory = fileManager.cacheDirectory().appendingPathComponent("media", isDirectory: true)
        }
        
        if let directory = configuration.baseDocumentsDirectory {
            self.documentsDirectory = directory
        } else {
            self.documentsDirectory = fileManager.documentsDirectory().appendingPathComponent("media", isDirectory: true)
        }
        
        for directory in [cacheDirectory, documentsDirectory] {
            if !fileManager.directoryExists(at: directory) {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }
        }
    }
    
    public func filePath(for mediaObject: MediaObject, in level: StorageLevel) -> URL {
        let directory: URL
        switch level {
        case .documents:
            directory = documentsDirectory
        case .cache:
            directory = cacheDirectory
        }
        
        return directory.appendingPathComponent(mediaObject.mediaFileName)
    }
    
    public func save(data: Data, for mediaObject: MediaObject, level: StorageLevel = .documents, shouldOverwriteExisting: Bool = true) async throws {
        let path = filePath(for: mediaObject, in: level)
        
        // Check if file exists already
        if fileManager.fileExists(at: path) {
            guard !shouldOverwriteExisting else {
                fatalError("Attempting to overwrite existing file")
            }
            
            try fileManager.removeItem(at: path)
        }
        
        try data.write(to: path)
    }
    
}
