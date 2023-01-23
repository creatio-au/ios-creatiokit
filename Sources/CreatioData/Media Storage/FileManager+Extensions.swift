//
//  FileManager+Extensions.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import Foundation

public extension FileManager {
    
    func documentsDirectory() -> URL {
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func cacheDirectory() -> URL {
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func directoryExists(at directory: URL) -> Bool {
        var isDirectory: ObjCBool = true
        return fileExists(atPath: directory.path, isDirectory: &isDirectory)
    }
    
    func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }
    
}
