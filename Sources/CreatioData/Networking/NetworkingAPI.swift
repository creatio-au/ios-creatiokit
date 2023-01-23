//
//  NetworkingAPI.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

public actor NetworkingAPI {
    
    public init(baseAPI: URL, session: URLSession = .shared, authenticationRefreshAction: ((NetworkingAPI) async throws -> Void)? = nil) {
        self.baseAPI = baseAPI
        self.session = session
        self.authenticationRefreshAction = authenticationRefreshAction
        self.authenticationMethod = .unauthenticated
    }
    
    private let baseAPI: URL
    private var session: URLSession
    private let authenticationRefreshAction: ((NetworkingAPI) async throws -> Void)?
    private var hasRefreshedAuthThisSession = false
    
    private var authenticationMethod: AuthenticationMethod
    public func setAuthentication(_ method: AuthenticationMethod, isNew: Bool = false) {
        self.authenticationMethod = method
        if isNew {
            self.hasRefreshedAuthThisSession = true
        }
    }
    
    public func request<Response: Decodable>(_ request: QueryRequest<Response>, queryItems: URLQueryItem...) async throws -> Response {
        try await self.request(request, queryItems: queryItems)
    }
    
    public func request<Response: Decodable>(_ request: QueryRequest<Response>, queryItems: [URLQueryItem]) async throws -> Response {
        try await prepareAndVerifyRequest(request)
        
        let urlRequest = try request.toURLRequest(
            withBasePath: baseAPI,
            authentication: request.requiresAuthentication ? authenticationMethod : .unauthenticated,
            queryItems: queryItems
        )
        
        let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
        return try handleResponseData(data: data, urlResponse: urlResponse, decoder: request.responseDecoder)
    }
    
    public func request<Body: Encodable, Response: Decodable>(_ request: BodyRequest<Body, Response>, body: Body) async throws -> Response {
        try await prepareAndVerifyRequest(request)
        
        let urlRequest = try request.toURLRequest(
            withBasePath: baseAPI,
            authentication: request.requiresAuthentication ? authenticationMethod : .unauthenticated,
            body: body
        )
        
        let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
        return try handleResponseData(data: data, urlResponse: urlResponse, decoder: request.responseDecoder)
    }
    
    public func request<Response: Decodable>(_ request: MultipartRequest<Response>, items: [MultipartDataItem]) async throws -> Response {
        try await prepareAndVerifyRequest(request)
        
        let urlRequest = try request.toURLRequest(
            withBasePath: baseAPI,
            authentication: request.requiresAuthentication ? authenticationMethod : .unauthenticated,
            items: items
        )
        
        let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
        return try handleResponseData(data: data, urlResponse: urlResponse, decoder: request.responseDecoder)
    }
    
    public func request<Response: Decodable>(_ request: MultipartRequest<Response>, items: MultipartDataItem...) async throws -> Response {
        try await self.request(request, items: items)
    }
    
    public func request<Response: Decodable>(_ request: URLRequest, decoder: JSONDecoder = .init()) async throws -> Response {
        var copy = request
        
        copy.allHTTPHeaderFields = [
            "X-User-Agent": "CreatioKit",
            //"Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        switch authenticationMethod {
        case .unauthenticated:
            break
        case .bearerToken(let token):
            copy.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, urlResponse) = try await session.data(for: copy, delegate: nil)
        return try handleResponseData(data: data, urlResponse: urlResponse, decoder: decoder)
    }
    
    public func delete(_ request: DeleteRequest) async throws {
        try await prepareAndVerifyRequest(request)
        
        let urlRequest = try request.toURLRequest(
            withBasePath: baseAPI,
            authentication: request.requiresAuthentication ? authenticationMethod : .unauthenticated
        )
        
        let (_, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            fatalError("Non HTTP response received")
        }
        
        switch httpURLResponse.statusCode {
        case 200...299:
            // Successful delete with no response
            break
        default:
            throw UnknownError(code: httpURLResponse.statusCode)
        }
    }
    
    private var authRefreshTask: Task<Void, Error>?
    private func prepareAndVerifyRequest(_ request: RequestProtocol) async throws {
        // We only need to prepare and verify requests that require authentication
        guard request.requiresAuthentication else {
            return
        }
        
        // Refresh authentication if needed
        if let action = authenticationRefreshAction, !hasRefreshedAuthThisSession {
            let task = authRefreshTask ?? Task {
                try await action(self)
            }
            
            authRefreshTask = task
            try await task.value
            hasRefreshedAuthThisSession = true
            authRefreshTask = nil
        }
        
        // Check we are properly authenticated
        switch authenticationMethod {
        case .unauthenticated:
            throw RequiredAuthenticationError()
        default:
            return
        }
    }
    
    private func handleResponseData<Response: Decodable>(data: Data, urlResponse: URLResponse, decoder: JSONDecoder) throws -> Response {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            fatalError("Non HTTP response received")
        }
        
        switch httpURLResponse.statusCode {
        case 200...299:
            #if DEBUG
            //if let rawJson = try? JSONSerialization.jsonObject(with: data) {
            //    debugPrint(rawJson)
            //}
            #endif
            
            return try decoder.decode(Response.self, from: data)
        case 400:
            throw BadRequestError(data: data)
        case 401:
            throw UnauthenticatedError()
        case 403:
            throw ForbiddenError()
        case 404:
            throw NotFoundError()
        case 500:
            throw InternalServerError()
        default:
            throw UnknownError(code: httpURLResponse.statusCode)
        }
    }
    
}

public struct NotFoundError: LocalizedError {
    public init() {}
    public var errorDescription: String? {
        "Not found"
    }
}

public struct ForbiddenError: LocalizedError {
    public var errorDescription: String? {
        "Action forbidden"
    }
}

public struct InternalServerError: LocalizedError {
    public var errorDescription: String? {
        "Internal server error"
    }
}

public struct BadRequestError: LocalizedError {
    init(data: Data) {
        if let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            self.contents = object
        } else {
            self.contents = [:]
        }
    }
    
    public var contents: [String: Any]
    public var errorDescription: String? {
        var description = ""
        for key in contents.keys {
            description += "\(key): \(self.description(forKey: key))\n"
        }
        
        if description == "" {
            description = "Unknown error code"
        }
        return description
    }
    
    private func description(forKey key: String) -> String {
        if let string = contents[key] as? String {
            return string
        } else if let items = contents[key] as? [String] {
            return items.joined(separator: ", ")
        } else {
            return "Unknown"
        }
    }
}

public struct UnauthenticatedError: Error {}

public struct UnknownError: LocalizedError {
    
    let code: Int
    
    public var errorDescription: String? {
        "Unknown error code: \(code)"
    }
}

public struct EmptyBody: Codable {
    public init() {}
}
