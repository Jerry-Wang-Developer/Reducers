// InAppPurchaser+DependencyKey.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/25.

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
