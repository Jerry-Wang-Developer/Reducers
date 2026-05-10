//
//  File.swift
//
//
//  Created by 王小涛 on 2023/6/16.
//

import Foundation

public final class CodableUserDefaultsStorage: CodableKeyValueStorage {
    private let userDefaults: UserDefaults
    
    private let serializer: any AnyEncodableSerializer
    private let deserializer: any AnyDecodableDeserializer

    public init(
        userDefaults: UserDefaults = .standard,
        serializer: any AnyEncodableSerializer = JSONEncoder(),
        deserializer: any AnyDecodableDeserializer = JSONDecoder()
    ){
        self.userDefaults = userDefaults
        self.serializer = serializer
        self.deserializer = deserializer
    }
    
    convenience public init?(
        suiteName: String,
        serializer: any AnyEncodableSerializer = JSONEncoder(),
        deserializer: any AnyDecodableDeserializer = JSONDecoder()
    ) {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            return nil
        }
        self.init(
            userDefaults: userDefaults,
            serializer: serializer,
            deserializer: deserializer
        )
    }

    public func save<Value>(_ value: Value?, forKey cachedKey: CachedKey<Value>) throws where Value: Codable {
        if let value {
            let data = try serializer.serialize(value)
            userDefaults.set(data, forKey: cachedKey.key)
        } else {
            userDefaults.set(nil, forKey: cachedKey.key)
        }
        userDefaults.synchronize()
    }
    
    public func value<Value>(forKey cachedKey: CachedKey<Value>) throws -> Value? where Value: Codable {
        if let data = userDefaults.data(forKey: cachedKey.key) {
            return try deserializer.deserialize(data)
        } else {
            return nil
        }
    }
}
