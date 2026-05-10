//
//  File 2.swift
//  
//
//  Created by 王小涛 on 2023/6/30.
//

import Foundation

public protocol CodableKeyValueStorage {
    func save<Value>(_ value: Value?, forKey: CachedKey<Value>) throws where Value: Codable
    func value<Value>(forKey: CachedKey<Value>) throws -> Value? where Value: Codable
}

public extension CodableKeyValueStorage {
    func value<Value>(forKey cachedKey: CachedKey<Value>, `default`: Value) -> Value where Value: Codable {
        do {
            return try value(forKey: cachedKey) ?? `default`
        } catch {
            return `default`
        }
    }
}
