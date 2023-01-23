//
//  BodyRequest.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

public struct BodyRequest<Body: Encodable, Response: Decodable>: RequestProtocol {
    
    var path: String
    var method: HttpMethod
    var requiresAuthentication: Bool
    var bodyType: Body.Type
    var bodyEncoder: JSONEncoder
    var responseType: Response.Type
    var responseDecoder: JSONDecoder
    
    public init(method: HttpMethod, path: String,  requiresAuthentication: Bool, bodyType: Body.Type, encoder: JSONEncoder = .snakeCaseConverting, responseType: Response.Type, decoder: JSONDecoder = .snakeCaseConverting) {
        self.path = path
        self.method = method
        self.requiresAuthentication = requiresAuthentication
        self.bodyType = bodyType
        self.bodyEncoder = encoder
        self.responseType = responseType
        self.responseDecoder = decoder
    }
    
    internal func toURLRequest(withBasePath basePath: URL, authentication: AuthenticationMethod, body: Body) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: basePath) else {
            throw FailedToBuildURLError(baseUrl: basePath, path: path)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = try bodyEncoder.encode(body)
        request.allHTTPHeaderFields = [
            "X-User-Agent": "CreatioKit",
            //"Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "application/json"
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
