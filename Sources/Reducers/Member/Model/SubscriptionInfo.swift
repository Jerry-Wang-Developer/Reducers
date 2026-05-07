//
//  SubscriptionInfo.swift
//  Reducers
//
//  Created by 王小涛 on 2026/5/6.
//

import Foundation
import MetaCodable
import StoreKit

extension Member.Product {
    @Codable
    public struct SubscriptionInfo: Equatable, Sendable {
        @CodedAt("period")
        public let period: Member.Product.SubscriptionPeriod

        @CodedAt("freeTrial")
        @Default(Member.Product.FreeTrial?.none)
        public let freeTrial: Member.Product.FreeTrial?

        @CodedAt("isEligibleForIntroOffer")
        public let isEligibleForIntroOffer: Bool

        init(_ subscriptionInfo: StoreKit::Product.SubscriptionInfo) async {
            period = .init(subscriptionInfo.subscriptionPeriod)
            if let introductoryOffer = subscriptionInfo.introductoryOffer,
               introductoryOffer.paymentMode == .freeTrial
            {
                freeTrial = .init(period: .init(introductoryOffer.period))
            } else {
                freeTrial = nil
            }
            isEligibleForIntroOffer = await subscriptionInfo.isEligibleForIntroOffer
        }
    }

    @Codable
    public struct FreeTrial: Equatable, Sendable {
        @CodedAt("period")
        public let period: Member.Product.SubscriptionPeriod
    }
}

extension Member.Product {
    @Codable
    public struct SubscriptionPeriod: Equatable, Sendable {
        public enum Unit: Equatable, Sendable, Codable {
            case day
            case week
            case month
            case year
        }

        @CodedAt("unit")
        public let unit: Unit

        @CodedAt("value")
        public let value: Int

        init(_ period: StoreKit::Product.SubscriptionPeriod) {
            unit = {
                switch period.unit {
                case .day: .day
                case .week: .week
                case .month: .month
                case .year: .year
                @unknown default: .day
                }
            }()

            value = period.value
        }
    }
}
