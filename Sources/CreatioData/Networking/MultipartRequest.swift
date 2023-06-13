//
//  MultipartRequest.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation
import UIKit

public struct MultipartDataItem {
    let name: String
    let value: Value
    
    public init(name: String, value: Value) {
        self.name = name
        self.value = value
    }
    
    public init?(name: String, value: Value?) {
        guard let value else {
            return nil
        }
        
        self.name = name
        self.value = value
    }
    
    public enum Value {
        case string(String)
        case file(data: Data, fileName: String, mimeType: String)
        
        public static func boolean(_ value: Bool) -> Value {
            .string(value ? "1" : "0")
        }
        
        public static func number(_ value: Int) -> Value {
            .string("\(value)")
        }
        
        public static func number(_ value: Double) -> Value {
            .string("\(value)")
        }
        
        public static func optional(_ value: String?) -> Value? {
            guard let value else {
                return nil
            }
            
            return .string(value)
        }
    }
    
    public static func fromImage(_ image: UIImage, withName name: String, compressionRatio: CGFloat = 0.8) -> MultipartDataItem? {
        guard let data = image.jpegData(compressionQuality: compressionRatio) else {
            return nil
        }
        
        return .init(name: name, value: .file(data: data, fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpg"))
    }
}

public struct MultipartRequest<Response: Decodable>: RequestProtocol {
    
    var path: String
    var method: HttpMethod
    var requiresAuthentication: Bool
    var responseType: Response.Type
    var responseDecoder: JSONDecoder
    
    public init(method: HttpMethod, path: String,  requiresAuthentication: Bool, responseType: Response.Type, decoder: JSONDecoder = .snakeCaseConverting) {
        self.path = path
        self.method = method
        self.requiresAuthentication = requiresAuthentication
        self.responseType = responseType
        self.responseDecoder = decoder
    }
    
    internal func toURLRequest(withBasePath basePath: URL, authentication: AuthenticationMethod, items: [MultipartDataItem]) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: basePath) else {
            throw FailedToBuildURLError(baseUrl: basePath, path: path)
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.allHTTPHeaderFields = [
            "X-User-Agent": "CreatioKit",
            //"Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        switch authentication {
        case .unauthenticated:
            break
        case .bearerToken(let token):
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let lineBreak = "\r\n"
        var body = Data()
        for item in items {
            switch item.value {
            case .string(let value):
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.name)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            case .file(let data, let fileName, let mimeType):
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.name)\"; filename=\"\(fileName)\"\(lineBreak)")
                body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
                body.append(data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        request.httpBody = body
        
        return request
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
