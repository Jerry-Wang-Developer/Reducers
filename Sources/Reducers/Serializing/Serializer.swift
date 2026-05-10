// Serializer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

public protocol Serializer<Input> {
    associatedtype Input
    func serialize(_ input: Input) throws -> Data
}

public protocol AnySerializer {
    func serialize<Input>(_ input: Input) throws -> Data
}

public protocol AnyEncodableSerializer {
    func serialize<Input>(_ input: Input) throws -> Data where Input: Encodable
}
