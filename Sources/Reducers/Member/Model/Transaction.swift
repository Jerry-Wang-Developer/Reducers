// Transaction.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import MetaCodable
import StoreKit

extension Member {
    @Codable
    public struct Transaction: Equatable, Sendable {
        @CodedAt("productID")
        public let productID: String

        @CodedAt("purchaseDate")
        public let purchaseDate: Date

        @CodedAt("originalPurchaseDate")
        public let originalPurchaseDate: Date

        @CodedAt("expirationDate")
        public let expirationDate: Date?

        @CodedAt("productType")
        public let productType: Member.ProductType?

        init(
            productID: String,
            purchaseDate: Date,
            originalPurchaseDate: Date,
            expirationDate: Date?,
            productType: ProductType?
        ) {
            self.productID = productID
            self.purchaseDate = purchaseDate
            self.originalPurchaseDate = originalPurchaseDate
            self.expirationDate = expirationDate
            self.productType = productType
        }

        init(_ transaction: StoreKit.Transaction) {
            productID = transaction.productID
            purchaseDate = transaction.purchaseDate
            originalPurchaseDate = transaction.originalPurchaseDate
            expirationDate = transaction.expirationDate
            productType = .init(transaction.productType)
        }

        public var isAvaliable: Bool {
            /**
             在应用内购买中，非续订性产品（non-renewable products）和非消耗性产品（non-consumable products）是两种不同的产品类型，它们具有以下区别：

             非续订性产品（Non-Renewable Products）：

             用户只需购买一次即可永久拥有该产品，不需要再次购买或续订。
             一旦用户购买了非续订性产品，他们将永久享受购买所提供的权益，无需再次付费。
             非续订性产品通常用于提供额外功能、解锁特定内容或移除广告等。

             非消耗性产品（Non-Consumable Products）：

             用户只需购买一次即可永久拥有该产品，不需要再次购买或续订。
             与非续订性产品类似，一旦购买，用户将永久享受购买所提供的权益。
             非消耗性产品通常用于提供永久性的虚拟货币、游戏道具或一次性服务等。
             */
            switch productType {
            case .consumable: // 金币
                // 当前没有这种类型，直接返回false
                return false

            case .nonConsumable: // 游戏道具，例如倚天剑，购买了就有了一直使用
                return true

            case .nonRenewable: // 永久会员
                return true

            case .autoRenewable: // 年度会员
                if let expiredDate = expirationDate {
                    let now: Date = .now
                    return expiredDate > now
                } else {
                    return false
                }

            default:
                return false
            }
        }
    }
}
