// InAppPurchasing.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/25.

import Foundation
import StoreKit

public protocol InAppPurchasing: Sendable {
    func product(productID: String) async throws -> Member.Product?
    func purchase(productID: String) async throws -> Member.Transaction?
    func latestTransaction(productID: String) async -> Member.Transaction?
    func restore() async throws -> [Member.Transaction]
}

struct InAppPurchaser: InAppPurchasing {
    private func product(productID: String) async throws -> StoreKit.Product? {
        let products = try await Product.products(for: [productID])
        let product = products.first
        return product
    }

    func product(productID: String) async throws -> Member.Product? {
        let product: StoreKit.Product? = try await product(productID: productID)
        return await product.asyncFlatMap(Member.Product.init(product:))
    }

    func purchase(productID: String) async throws -> Member.Transaction? {
        guard let product: StoreKit.Product = try await product(productID: productID) else {
            return nil
        }

        let result = try await product.purchase()
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            return .init(transaction)

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

    func latestTransaction(productID: String) async -> Member.Transaction? {
        guard let transation = await StoreKit.Transaction.latest(for: productID) else { return nil }
        switch transation {
        case let .verified(transation):
            return .init(transation)
        case .unverified:
            return nil
        }
    }
    
    
    func restore() async throws -> [Member.Transaction] {
        try await AppStore.sync()
         
        var transactions: [Member.Transaction] = []
        
        for await result in Transaction.currentEntitlements {
            if case let .verified(transation) = result {
                transactions.append(Member.Transaction.init(transation))
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
