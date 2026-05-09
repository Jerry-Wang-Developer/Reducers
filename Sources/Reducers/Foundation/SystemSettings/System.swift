// System.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/4/30.

import Foundation

public struct System<Base> {
    public let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public protocol SystemCompatible {
    associatedtype SystemCompatibleType
    static var system: SystemCompatibleType.Type { get }
    var system: SystemCompatibleType { get }
}

extension SystemCompatible {
    public static var system: System<Self>.Type {
        System<Self>.self
    }

    public var system: System<Self> {
        System(self)
    }
}
