// InAppPurchasing.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import StoreKit

public protocol InAppPurchasing: Sendable {
    func product(productID: String) async throws -> StoreKit::Product?
    func purchase(productID: String) async throws -> StoreKit::Transaction?
    func latestTransaction(productID: String) async -> StoreKit::Transaction?
    func restore() async throws -> [StoreKit::Transaction]
}

struct InAppPurchaser: InAppPurchasing {
    func product(productID: String) async throws -> StoreKit::Product? {
        let products = try await StoreKit::Product.products(for: [productID])
        let product = products.first
        return product
    }

    func purchase(productID: String) async throws -> StoreKit::Transaction? {
        guard let product: StoreKit.Product = try await product(productID: productID) else {
            return nil
        }

        let result = try await product.purchase()
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            return transaction

        case .success(.unverified):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            return nil

        case .userCancelled:
            return nil

        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            return nil

        @unknown default:
            return nil
        }
    }

    func latestTransaction(productID: String) async -> StoreKit::Transaction? {
        guard let transation = await StoreKit.Transaction.latest(for: productID) else { return nil }
        switch transation {
        case let .verified(transation):
            return transation
        case .unverified:
            return nil
        }
    }

    func restore() async throws -> [StoreKit::Transaction] {
        try await AppStore.sync()

        var transactions: [StoreKit::Transaction] = []

        for await result in Transaction.currentEntitlements {
            if case let .verified(transation) = result {
                transactions.append(transation)
            }
        }

        return transactions
    }
}

extension Optional {
    func asyncMap<T>(
        _ transform: (Wrapped) async throws -> T
    ) async rethrows -> T? {
        switch self {
        case let .some(wrapped):
            return try await transform(wrapped)
        case .none:
            return nil
        }
    }

    func asyncFlatMap<T>(
        _ transform: (Wrapped) async throws -> T?
    ) async rethrows -> T? {
        switch self {
        case let .some(wrapped):
            return try await transform(wrapped)
        case .none:
            return nil
        }
    }
}


extension Transaction {
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
