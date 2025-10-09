// SubscriptionPeriod.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Foundation
import MetaCodable
import StoreKit

extension Member {
    @Codable
    public struct SubscriptionPeriod: Equatable, Sendable {
        public enum Unit: Equatable, Sendable, Codable {
            case day
            case week
            case month
            case year
        }

        @CodedAt("unit")
        public let unit: Member.SubscriptionPeriod.Unit

        @CodedAt("value")
        public let value: Int

        init(
            unit: Unit,
            value: Int
        ) {
            self.unit = unit
            self.value = value
        }

        init(_ period: StoreKit.Product.SubscriptionPeriod) {
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
