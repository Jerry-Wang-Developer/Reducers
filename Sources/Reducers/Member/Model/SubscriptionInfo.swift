// SubscriptionInfo.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/27.

import Foundation
import StoreKit
import MetaCodable

extension Member {
    @Codable
    public struct SubscriptionInfo: Equatable, Sendable {
        @CodedAt("period")
        public let period: Member.SubscriptionPeriod
        
        @CodedAt("freeTrial")
        public let freeTrial: Member.FreeTrial?
        
        @CodedAt("isEligibleForIntroOffer")
        public let isEligibleForIntroOffer: Bool
                
        init(
            period: SubscriptionPeriod,
            freeTrial: FreeTrial?,
            isEligibleForIntroOffer: Bool
        ) {
            self.period = period
            self.freeTrial = freeTrial
            self.isEligibleForIntroOffer = isEligibleForIntroOffer
        }

        init?(_ subscriptionInfo: StoreKit.Product.SubscriptionInfo?) async {
            guard let subscriptionInfo else { return nil }
            period = .init(subscriptionInfo.subscriptionPeriod)
            if let introductoryOffer = subscriptionInfo.introductoryOffer,
               introductoryOffer.paymentMode == .freeTrial {
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
        public let period: Member.SubscriptionPeriod
    }
}
