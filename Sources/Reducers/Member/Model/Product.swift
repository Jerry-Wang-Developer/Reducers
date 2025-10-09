// Product.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import ComposableArchitecture
import Foundation
import MetaCodable
import StoreKit

public extension Member {
    @Codable
    struct Product: Equatable, Sendable {
        @CodedAt("productID")
        public var productID: String

        @IgnoreCoding
        @Shared(.appStorage("discount"))
        private var discount: Int? = nil

        @CodedAt("displayName")
        public let displayName: String

        @CodedAt("description")
        public let description: String

        @CodedAt("price")
        public let price: Decimal

        public var originalPrice: Decimal? {
            discount.flatMap {
                price * 100 / Decimal($0)
            }
        }

        @CodedAt("currency")
        public let priceFormatStyle: Decimal.FormatStyle.Currency

        @CodedAt("subscription")
        public let subscription: Member.SubscriptionInfo?

        init(
            productID: String,
            displayName: String,
            description: String,
            price: Decimal,
            priceFormatStyle: Decimal.FormatStyle.Currency,
            subscription: Member.SubscriptionInfo?
        ) {
            self.productID = productID
            self.displayName = displayName
            self.description = description
            self.price = price
            self.priceFormatStyle = priceFormatStyle

            self.subscription = subscription
        }

        init(product: StoreKit.Product) async {
            productID = product.id
            displayName = product.displayName
            description = product.description
            price = product.price
            priceFormatStyle = product.priceFormatStyle

            subscription = await .init(product.subscription)
        }

//        private func extractCurrency(from displayPrice: String) -> String? {
//            // 定义正则表达式模式
//            let pattern = #"^([^\d]+)([\d.,]+)$"#
//
//            // 创建正则表达式对象
//            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
//                return nil
//            }
//
//            // 匹配字符串
//            let matches = regex.matches(in: displayPrice, options: [], range: NSRange(location: 0, length: displayPrice.count))
//            guard let match = matches.first else {
//                return nil
//            }
//
//            // 提取货币符号
//            let currencySymbolRange = match.range(at: 1)
//            let currencySymbol = (displayPrice as NSString).substring(with: currencySymbolRange)
//
//            // 提取价格
//            let priceRange = match.range(at: 2)
//            let price = (displayPrice as NSString).substring(with: priceRange)
//
//            return currencySymbol
//        }
    }
}
