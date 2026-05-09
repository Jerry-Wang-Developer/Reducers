// Member.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2026/5/9.

import ComposableArchitecture
import Foundation
import MetaCodable
import StoreKit

@Codable
public struct Member: Equatable, Sendable {
    @CodedAt("productID")
    public let productID: String

    @CodedAt("displayName")
    public let displayName: String

    @CodedAt("latestTransaction")
    public var latestTransaction: Product.Transaction

    // 是否已经购买并且还没过期
    public var isAvaliable: Bool {
        return latestTransaction.isAvaliable
    }
}
