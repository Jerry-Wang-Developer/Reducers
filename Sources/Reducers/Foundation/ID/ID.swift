// ID.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/4/30.

import Foundation
import SwiftUI

// Refer to https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/
public protocol TypeSafeIdentifiable {
    associatedtype RawIdentifier = UUID
    var id: ID<Self> { get }
}

public struct ID<T: TypeSafeIdentifiable> {
    public let rawValue: T.RawIdentifier

    public init(rawValue: T.RawIdentifier) {
        self.rawValue = rawValue
    }
}

extension ID: Equatable where T.RawIdentifier: Equatable {}
extension ID: Codable where T.RawIdentifier: Codable {}
extension ID: Hashable where T.RawIdentifier: Hashable {}
extension ID: Sendable where T.RawIdentifier: Sendable {}

extension Identifiable where Self: TypeSafeIdentifiable {}
