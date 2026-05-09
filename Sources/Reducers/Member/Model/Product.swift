// Product.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import MetaCodable
import StoreKit

@Codable
public struct Product: Equatable, Sendable {
    @CodedAt("productID")
    public let productID: String

    @CodedAt("productName")
    public let productName: String

    @CodedAt("productID")
    private let discount: Int?

    @CodedAt("details")
    @Default(Product.Details?.none)
    public internal(set) var details: Product.Details?

    @CodedAt("subscription")
    @Default(Product.SubscriptionInfo?.none)
    public internal(set) var subscription: Product.SubscriptionInfo?

    public var originalPrice: Decimal? {
        guard let details else { return nil }
        return discount.flatMap {
            details.price * 100 / Decimal($0)
        }
    }

    init(
        productID: String,
        productName: String,
        discount: Int? = nil
    ) {
        self.productID = productID
        self.productName = productName
        self.discount = discount
    }
}

extension Product {
    @Codable
    public struct Details: Equatable, Sendable {
        @CodedAt("displayName")
        public let displayName: String

        @CodedAt("description")
        public let description: String

        @CodedAt("price")
        public let price: Decimal

        @CodedAt("currency")
        public let priceFormatStyle: Decimal.FormatStyle.Currency

        init(product: StoreKit:: Product) {
            displayName = product.displayName
            description = product.description
            price = product.price
            priceFormatStyle = product.priceFormatStyle
        }
    }
}

extension Product {
    public enum ProductType: String, Equatable, Sendable, Codable {
        // 不要修改rawValue名字，要和Transaction中的ProductType的rawVluae一致。
        case consumable
        case nonConsumable
        case nonRenewable
        case autoRenewable

        init?(_ productType: StoreKit:: Product.ProductType) {
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
