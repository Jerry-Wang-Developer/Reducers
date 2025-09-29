// SubscriptionPeriod.swift
// Copyright (c) 2024 Nostudio
// Created by Jerry X T Wang on 2024/2/27.

import Foundation
import StoreKit
import MetaCodable

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
