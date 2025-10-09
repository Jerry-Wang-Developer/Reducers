// InAppPurchaser+DependencyKey.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Dependencies

public extension DependencyValues {
    var inAppPurchaser: any InAppPurchasing {
        get { self[InAppPurchaser.self] }
        set { self[InAppPurchaser.self] = newValue }
    }
}

extension InAppPurchaser: DependencyKey {
    static let liveValue: any InAppPurchasing = InAppPurchaser()
}
