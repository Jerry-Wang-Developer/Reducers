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
