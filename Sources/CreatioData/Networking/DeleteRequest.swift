//
//  DeleteRequest.swift
//  
//
//  Created by Davis Allie on 13/6/2022.
//

import Foundation

public struct DeleteRequest: RequestProtocol {
    
    var path: String
    var method: HttpMethod
    var requiresAuthentication: Bool
    
    public init(path: String, requiresAuthentication: Bool) {
        self.path = path
        self.method = .delete
        self.requiresAuthentication = requiresAuthentication
    }
    
    internal func toURLRequest(withBasePath basePath: URL, authentication: AuthenticationMethod) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: basePath) else {
            throw FailedToBuildURLError(baseUrl: basePath, path: path)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.allHTTPHeaderFields = [
            "X-User-Agent": "CreatioKit",
            //"Accept-Language": "en",
            "Accept": "application/json"
        ]
        
        switch authentication {
        case .unauthenticated:
            break
        case .bearerToken(let token):
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
}
