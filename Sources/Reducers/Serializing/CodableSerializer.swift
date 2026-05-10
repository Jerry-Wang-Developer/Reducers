// CodableSerializer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

public final class EncodableSerializer<Input>: Serializer where Input: Encodable {
    let serializer: AnyEncodableSerializer

    init(serializer: AnyEncodableSerializer) {
        self.serializer = serializer
    }

    public func serialize(_ input: Input) throws -> Data {
        try serializer.serialize(input)
    }
    
    public convenience init(encoder: JSONEncoder = .init()) {
        self.init(serializer: encoder)
    }
}

extension JSONDecoder {
    func decode<T>(from data: Data) throws -> T where T: Decodable {
        try decode(T.self, from: data)
    }
}

public final class DecodableDeserializer<Output>: Deserializer where Output: Decodable {
    private let deserializer: AnyDecodableDeserializer

    init(deserializer: AnyDecodableDeserializer) {
        self.deserializer = deserializer
    }
    
    public convenience init(decoder: JSONDecoder = .init()) {
        self.init(deserializer: decoder)
    }

    public func deserialize(_ data: Data) throws -> Output {
        try deserializer.deserialize(data)
    }
}
