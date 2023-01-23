//
//  QueryRequest.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

public struct FailedToBuildURLError: LocalizedError {
    var baseUrl: URL
    var path: String
    
    public var errorDescription: String? {
        return "Failed to create URL\n\nBase URL: \(baseUrl)\nPath: \(path)"
    }
}

public struct FailedToBuildQueryURLError: LocalizedError {
    var url: URL
    var queryItems: [URLQueryItem]?
    
    public var errorDescription: String? {
        return "Failed to create URL\n\nBase URL: \(url)\nQuery items: \(String(describing: queryItems))"
    }
}

public struct QueryRequest<Response: Decodable>: RequestProtocol {
    
    var path: String
    var method: HttpMethod
    var requiresAuthentication: Bool
    var responseType: Response.Type
    var responseDecoder: JSONDecoder
    
    public init(method: HttpMethod, path: String, requiresAuthentication: Bool, responseType: Response.Type, decoder: JSONDecoder = .snakeCaseConverting) {
        self.path = path
        self.method = method
        self.requiresAuthentication = requiresAuthentication
        self.responseType = responseType
        self.responseDecoder = decoder
    }
    
    internal func toURLRequest(withBasePath basePath: URL, authentication: AuthenticationMethod, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: basePath) else {
            throw FailedToBuildURLError(baseUrl: basePath, path: path)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw FailedToBuildQueryURLError(url: url, queryItems: queryItems)
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
