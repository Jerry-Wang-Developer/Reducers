// Member.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/25.

import ComposableArchitecture
import Foundation
import MetaCodable
import ComposableArchitecture

@Reducer
public struct Member {
    @ObservableState
    @Codable
    public struct State: Equatable, Sendable {
        @CodedAt("productID")
        public let productID: String
        
        @Shared(.appStorage("discount"))
        @CodedAt("discount")

        @Default(Int?.none)
        public private(set) var discount: Int?
 
        @CodedAt("product")
        @Default(Member.Product?.none)
        public var product: Member.Product?
        
        @CodedAt("latestTransaction")
        @Default(Member.Transaction?.none)
        var latestTransaction: Member.Transaction?

        @IgnoreCoding
        public var isSyncing: Bool = false
        
        @IgnoreCoding
        public var isPurchasing: Bool = false

        // 是否已经购买并且还没过期
        public var isAvaliable: Bool {
            guard let latestTransaction else {
                return false
            }

            return latestTransaction.isAvaliable
        }
        
        public init(
            productID: String,
            discount: Int? = nil
        ) {
            self.productID = productID
            self.$discount.withLock {
                $0 = $0.flatMap { max(1, min($0, 100)) }
            }
//            self.discount = discount.flatMap { max(1, min($0, 100)) }
        }
        
        init(
            productID: String,
            discount: Int? = nil,
            product: Product? = nil
        ) {
            self.productID = productID
            self.$discount.withLock { $0 = discount }
//            self.discount = discount
            self.product = product
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case sync
        case purchase

        case _updateIsSyncing(Bool)
        case _updateIsPurchasing(Bool)

        case _loadProduct
        case _updateProduct(Product)
        case _loadLatestTransaction
        case _updateLatestTransaction(Transaction?)
    }

    @Dependency(\.inAppPurchaser) var inAppPurchaser
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sync:
                return .run { send in
                    await send(._updateIsSyncing(true))
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            await send(._loadProduct)
                        }
                        group.addTask {
                            await send(._loadLatestTransaction)
                        }
                    }
                    await send(._updateIsSyncing(false))
                }

            case .purchase:
                guard !state.isPurchasing else {
                    return .none
                }

                return .run { [state, inAppPurchaser] send in
                        await send(._updateIsPurchasing(true))
                        let transaction = try await inAppPurchaser.purchase(productID: state.productID)
                        await send(._updateLatestTransaction(transaction))
                        await send(._updateIsPurchasing(false))
                }

            case let ._updateIsSyncing(isSyning):
                state.isSyncing = isSyning
                return .none

            case let ._updateIsPurchasing(isPurchasing):
                state.isPurchasing = isPurchasing
                return .none

            case ._loadProduct:
                return .run { [state, inAppPurchaser] send in
                    guard let product = try await inAppPurchaser.product(productID: state.productID) else {
                        return
                    }

                    await send(._updateProduct(product))
                }

            case let ._updateProduct(product):
                state.product = product
                return .none

            case ._loadLatestTransaction:
                return .run { [state, inAppPurchaser] send in
                    let transaction = await inAppPurchaser.latestTransaction(productID: state.productID)
                    await send(._updateLatestTransaction(transaction))
                }

            case let ._updateLatestTransaction(transaction):
                state.latestTransaction = transaction
                return .none
            }
        }
    }
}

extension Member.State: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productID = try container.decode(String.self, forKey: CodingKeys.productID)
        do {
            try self.$discount.withLock {
                $0 = try container.decodeIfPresent(Int.self, forKey: CodingKeys.discount) ?? Int?.none
            }
        } catch {
            self.$discount.withLock {
                $0 = Int?.none
            }
        }
        do {
            self.product = try container.decodeIfPresent(Member.Product.self, forKey: CodingKeys.product) ?? Member.Product?.none
        } catch {
            self.product = Member.Product?.none
        }
        do {
            self.latestTransaction = try container.decodeIfPresent(Member.Transaction.self, forKey: CodingKeys.latestTransaction) ?? Member.Transaction?.none
        } catch {
            self.latestTransaction = Member.Transaction?.none
        }
    }
}
