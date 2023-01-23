//
//  Coders.swift
//  
//
//  Created by Davis Allie on 28/4/2022.
//

import Foundation

public extension JSONEncoder {
    
    static var snakeCaseConverting: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
}

public extension JSONDecoder {
    
    static var snakeCaseConverting: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
}
