//
//  File.swift
//  
//
//  Created by 王小涛 on 2023/6/16.
//

import Foundation

extension JSONDecoder: AnyDecodableDeserializer {
    public func deserialize<Output>(_ data: Data) throws -> Output where Output : Decodable {
        try decode(from: data)
    }
}
