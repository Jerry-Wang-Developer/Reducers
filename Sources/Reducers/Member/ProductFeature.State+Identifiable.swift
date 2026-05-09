// ProductFeature.State+Identifiable.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation

extension ProductFeature.State: TypeSafeIdentifiable, Identifiable {
    public typealias RawIdentifier = String

    public var id: ID<Self> {
        ID(rawValue: product.productID)
    }
}
