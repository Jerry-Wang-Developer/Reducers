// ProductsFeature.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2026/5/7.

import ComposableArchitecture
import Foundation
import MetaCodable

@Reducer
public struct ProductsFeature {
    @ObservableState
    @Codable
    public struct State: Sendable, Equatable {
        @CodedAt("products")
        public var products: IdentifiedArrayOf<ProductFeature.State>

        @IgnoreCoding
        public var isFetching: Bool = false

        @IgnoreCoding
        public var isRestoring: Bool = false
    }

    @CasePathable
    public enum Action {
        case products(IdentifiedActionOf<ProductFeature>)
        case fetch
        case setIsFetching(Bool)
        case restore
        case setIsRestoring(Bool)
    }

    @Dependency(\.inAppPurchaser) var inAppPurchaser

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                return .run { [state] send in
                    await send(.setIsFetching(true))
                    for id in state.products.ids {
                        await send(.products(.element(id: id, action: .fetch)))
                    }
                    await send(.setIsFetching(false))
                }

            case let .setIsFetching(flag):
                state.isFetching = flag
                return .none

            case .restore:
                return .run { [state] send in
                    await send(.setIsRestoring(true))
                    for id in state.products.ids {
                        await send(.products(.element(id: id, action: .restore)))
                    }
                    await send(.setIsRestoring(false))
                }

            case let .setIsRestoring(flag):
                state.isRestoring = flag
                return .none

            case .products:
                return .none
            }
        }
        .forEach(\.products, action: \.products) {
            ProductFeature()
        }
    }
}
