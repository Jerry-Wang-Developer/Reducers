// Member.State+Identifiable.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import MobileCore

extension MemberFeature.State: TypeSafeIdentifiable, Identifiable {
    public typealias RawIdentifier = String

    public var id: ID<Self> {
        ID(rawValue: product.productID)
    }
}
