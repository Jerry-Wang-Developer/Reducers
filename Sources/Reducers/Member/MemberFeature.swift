// Member.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import ComposableArchitecture
import Foundation
import StoreKit
import MetaCodable

@Reducer
public struct MemberFeature : Sendable{
    @ObservableState
    @Codable
    public struct State: Equatable, Sendable {
        @CodedAt("product")
        public internal(set) var product: Member.Product

        @IgnoreCoding
        public var isSyncing: Bool = false

        @IgnoreCoding
        public var isPurchasing: Bool = false

        // 是否已经购买并且还没过期
        public var isAvaliable: Bool {
            guard let latestTransaction = product.latestTransaction else {
                return false
            }

            return latestTransaction.isAvaliable
        }

        public init(
            productID: String,
            discount: Int? = nil
        ) {
            self.product = .init(productID: productID, discount: discount)
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case sync
        case purchase
        
        case updateIsSyncing(Bool)
        case updateIsPurchasing(Bool)
        
        case updateDetails(Member.Product.Details)
        case updateSubscription(Member.Product.SubscriptionInfo)
        case updateLatestTransaction(Member.Product.Transaction)
    }

    @Dependency(\.inAppPurchaser) var inAppPurchaser

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sync:
                guard !state.isSyncing else { return .none }
                
                return .run { [state] send in
                    await send(.updateIsSyncing(true))
                    if let product = try await inAppPurchaser.product(productID: state.product.productID) {
                        await send(.updateDetails(.init(product: product)))
                        if let subscription = product.subscription {
                            await send(.updateSubscription(await .init(subscription)))
                        }
                    }
                    
                    if let transaction = await inAppPurchaser.latestTransaction(productID: state.product.productID) {
                        await send(.updateLatestTransaction(.init(transaction)))
                    }

                    await send(.updateIsSyncing(false))
                }

            case .purchase:
                guard !state.isPurchasing else { return .none }

                return .run { [state] send in
                    await send(.updateIsPurchasing(true))
                    if let transaction = try await inAppPurchaser.purchase(productID: state.product.productID) {
                        await send(.updateLatestTransaction(.init(transaction)))
                    }
                    await send(.updateIsPurchasing(false))
                }
                
            case let .updateIsSyncing(isSyncing):
                state.isSyncing = isSyncing
                return .none
                
            case let .updateIsPurchasing(isPurchasing):
                state.isPurchasing = isPurchasing
                return .none
                
            case let .updateDetails(details):
                state.product.details = details
                return .none
                
            case let .updateSubscription(subscription):
                state.product.subscription = subscription
                return .none
                
            case let .updateLatestTransaction(transation):
                state.product.latestTransaction = transation
                return .none
            }
        }
    }
}

extension MemberFeature.State: Decodable {
    public nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.product = try container.decode(Member.Product.self, forKey: CodingKeys.product)
    }
}

extension MemberFeature.State: Encodable {
    public nonisolated func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.product, forKey: CodingKeys.product)
    }
}

extension MemberFeature.State {
    enum CodingKeys: String, CodingKey {
        case product = "product"
    }
}
