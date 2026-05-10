//
//  File.swift
//  
//
//  Created by 王小涛 on 2023/6/16.
//

import Foundation

public protocol KeyValueStorage<Value> {
    associatedtype Value
    func save(_ value: Value?, forKey: CachedKey<Value>) throws
    func value(forKey: CachedKey<Value>) throws -> Value?
}

public extension KeyValueStorage {
    func value(forKey cachedKey: CachedKey<Value>, `default`: Value) -> Value? {
        do {
            return try value(forKey: cachedKey) ?? `default`
        } catch {
            return `default`
        }
    }
}


public struct CachedKey<Value>: ExpressibleByStringLiteral {
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public init(stringLiteral value: String) {
        self.key = value
    }
}


