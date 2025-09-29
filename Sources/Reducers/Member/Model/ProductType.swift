// ProductType.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/27.

import Foundation
import StoreKit
import MetaCodable

extension Member {
    public enum ProductType: String, Equatable, Sendable, Codable {
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
