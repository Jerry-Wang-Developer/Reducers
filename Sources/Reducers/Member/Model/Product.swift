//
//  Product.swift
//  Reducers
//
//  Created by 王小涛 on 2026/5/6.
//

import Foundation
import MetaCodable
import StoreKit

public enum Member {}

extension Member {
    @Codable
    public struct Product: Equatable, Sendable {
        @CodedAt("productID")
        public let productID: String
        
        @CodedAt("productID")
        private let discount: Int?
        
        @CodedAt("details")
        @Default(Member.Product.Details?.none)
        public internal(set) var details: Member.Product.Details?
        
        @CodedAt("subscription")
        @Default(Member.Product.SubscriptionInfo?.none)
        public internal(set) var subscription: Member.Product.SubscriptionInfo?
        
        @CodedAt("latestTransaction")
        @Default(Member.Product.Transaction?.none)
        public internal(set) var latestTransaction: Member.Product.Transaction?
        
        public var originalPrice: Decimal? {
            guard let details else { return nil }
            return discount.flatMap {
                details.price * 100 / Decimal($0)
            }
        }
        
        init(
            productID: String,
            discount: Int? = nil
        ) {
            self.productID = productID
            self.discount = discount
        }
    }
}

extension Member.Product {
    @Codable
    public struct Details: Equatable, Sendable{
        @CodedAt("displayName")
        public let displayName: String
        
        @CodedAt("description")
        public let description: String
        
        @CodedAt("price")
        public let price: Decimal
        
        @CodedAt("currency")
        public let priceFormatStyle: Decimal.FormatStyle.Currency
        
        init(product: StoreKit::Product) {
            displayName = product.displayName
            description = product.description
            price = product.price
            priceFormatStyle = product.priceFormatStyle
        }
    }
}

extension Member.Product {
    public enum ProductType: String, Equatable, Sendable, Codable {
        // 不要修改rawValue名字，要和Transaction中的ProductType的rawVluae一致。
        case consumable
        case nonConsumable
        case nonRenewable
        case autoRenewable
        
        init?(_ productType: StoreKit::Product.ProductType) {
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
