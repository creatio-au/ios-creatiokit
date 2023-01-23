//
//  UserDefault.swift
//  
//
//  Created by Davis Allie on 28/4/2022.
//

import Foundation

@MainActor
@propertyWrapper
public struct UserDefault<Value> {
    
    public let key: String
    public let defaultValue: Value

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
}

@MainActor
@propertyWrapper
public struct UserDefaultSet<ValueType: Hashable> {
    
    public let key: String
    public let defaultValue: Set<ValueType>

    public init(_ key: String, defaultValue: Set<ValueType>) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Set<ValueType> {
        get {
            if let array = UserDefaults.standard.object(forKey: key) as? [ValueType] {
                return Set(array)
            } else {
                return defaultValue
            }
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }
    
}

@MainActor
@propertyWrapper
public struct OptionalUserDefault<Value> {
    
    public let key: String

    public init(_ key: String = #function) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
}

@MainActor
@propertyWrapper
public struct CodableUserDefault<Value: Codable> {
    
    public let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            
            return try? decoder.decode(Value.self, from: data)
        }
        set {
            let encoder = JSONEncoder()
            if let value = newValue, let data = try? encoder.encode(value) {
                UserDefaults.standard.set(data, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
}
