//
//  VersionChecker.swift
//  
//
//  Created by Davis Allie on 1/12/2022.
//

import UIKit

public class VersionChecker {
    
    struct LookupResult: Codable {
        var minimumOsVersion: String
        var version: String
        
        struct Wrapper: Codable {
            var results: [LookupResult]
        }
    }
    
    public enum Result {
        case upToDate
        case updateAvailable(version: String)
    }
    
    public struct Error: LocalizedError {
        
    }
    
    public static func checkForAppUpdate(
        bundleId: String? = Bundle.main.bundleIdentifier,
        countryCode: String = "au"
    ) async throws -> Result {
        guard let bundleId else {
            throw Error()
        }
        
        let url = URL(string: "https://itunes.apple.com/\(countryCode)/lookup?bundleId=\(bundleId)")!
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        let decoder = JSONDecoder()
        let wrappedResult = try decoder.decode(LookupResult.Wrapper.self, from: data)
        guard let result = wrappedResult.results.first else {
            throw Error()
        }
        
        let currentOSVersion = await UIDevice.current.systemVersion.comparableVersionNumber
        let currentAppVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).comparableVersionNumber
        
        let supportedOSVersion = result.minimumOsVersion.comparableVersionNumber
        let latestAppVersion = result.version.comparableVersionNumber
        
        if currentOSVersion >= supportedOSVersion && currentAppVersion < latestAppVersion {
            return .updateAvailable(version: result.version)
        } else {
            return .upToDate
        }
    }
    
}

fileprivate extension String {
    var comparableVersionNumber: Int {
        var result = 0
        let components = self.split(separator: ".").compactMap {
            Int(String($0))
        }
        
        for (i, part) in components.enumerated() {
            let multiplier: Int
            switch i {
            case 0: multiplier = 1_000_000
            case 1: multiplier = 1_000
            default: multiplier = 1
            }
            
            result += (multiplier*part)
        }
        
        return result
    }
}
