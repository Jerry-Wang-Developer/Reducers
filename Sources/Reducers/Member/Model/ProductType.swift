// ProductType.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import MetaCodable
import StoreKit

public extension Member {
    enum ProductType: String, Equatable, Sendable, Codable {
        // 不要修改rawValue名字，要和Transaction中的ProductType的rawVluae一致。
        case consumable
        case nonConsumable
        case nonRenewable
        case autoRenewable

        init?(_ productType: StoreKit.Product.ProductType) {
            switch productType {
            case .consumable:
                self = .consumable
            case .nonConsumable:
                self = .nonConsumable
            case .nonRenewable:
                self = .nonRenewable
            case .autoRenewable:
                self = .autoRenewable
            default:
                return nil
            }
        }
    }
}
