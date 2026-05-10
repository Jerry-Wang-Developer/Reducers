// ProductFeature.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2026/5/7.

import ComposableArchitecture
import Foundation
import MetaCodable
import StoreKit

@Reducer
public struct ProductFeature {
    @ObservableState
    @Codable
    public struct State: Equatable, Sendable {
        @CodedAt("product")
        public internal(set) var product: Product

        @IgnoreCoding
        @Shared(.member)
        public var member: Member?

        @IgnoreCoding
        public var isFetching: Bool = false

        @IgnoreCoding
        public var isPurchasing: Bool = false

        public init(
            productID: String,
            productName: String,
            discount: Int? = nil
        ) {
            product = .init(productID: productID, productName: productName, discount: discount)
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case fetch
        case setIsFetching(Bool)

        case purchase
        case setIsPurchasing(Bool)

        case updateProduct(StoreKit.Product?)
        case _updateSubscriptionInfo(Product.SubscriptionInfo?)

        case restore
        case _updateLatestTransaction(Transaction?)
    }

    @Dependency(\.inAppPurchaser) var inAppPurchaser

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetch:
                return .run { [state, inAppPurchaser] send in
                    await send(.setIsFetching(true))
                    let product = try await inAppPurchaser.product(productID: state.product.productID)
                    await send(.updateProduct(product))
                    await send(.setIsFetching(false))
                }

            case let .setIsFetching(flag):
                state.isFetching = flag
                return .none

            case .purchase:
                guard !state.isPurchasing else { return .none }

                return .run { [state, inAppPurchaser] send in
                    await send(.setIsPurchasing(true))
                    let transaction = try await inAppPurchaser.purchase(productID: state.product.productID)
                    await send(._updateLatestTransaction(transaction))
                    await send(.setIsPurchasing(false))
                }

            case let .setIsPurchasing(flag):
                state.isPurchasing = flag
                return .none

            case let .updateProduct(product):
                state.product.details = product.flatMap(Product.Details.init(product:))

                return .run { send in
                    let subscription = await product?.subscription.asyncFlatMap(Product.SubscriptionInfo.init)
                    await send(._updateSubscriptionInfo(subscription))
                }

            case let ._updateSubscriptionInfo(info):
                state.product.subscription = info
                return .none

            case .restore:
                return .run { [state, inAppPurchaser] send in
                    let transaction = await inAppPurchaser.latestTransaction(productID: state.product.productID)
                    await send(._updateLatestTransaction(transaction))
                }

            case let ._updateLatestTransaction(transaction):
                if let transaction, transaction.isAvaliable {
                    let member = Member(
                        productID: state.product.productID,
                        displayName: state.product.productName,
                        latestTransaction: .init(transaction)
                    )
                    state.$member.withLock { $0 = member }
                }
                return .none
            }
        }
    }
}
