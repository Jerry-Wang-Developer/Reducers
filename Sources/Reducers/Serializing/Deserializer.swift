//
//  File.swift
//  
//
//  Created by 王小涛 on 2023/6/16.
//

import Foundation

public protocol Deserializer<Output> {
    associatedtype Output
    func deserialize(_ data: Data) throws -> Output
}

public protocol AnyDeserializer {
    func deserialize<Output>(_ data: Data) throws -> Output
}

public protocol AnyDecodableDeserializer {
    func deserialize<Output>(_ data: Data) throws -> Output where Output: Decodable
}
