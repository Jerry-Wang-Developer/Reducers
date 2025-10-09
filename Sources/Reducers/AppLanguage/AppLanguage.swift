// AppLanguage.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Dependencies
import Foundation
import MobileCore

public extension DependencyValues {
    var language: any AppLanguageProviding {
        get { self[AppLanguageProvider.self] }
        set { self[AppLanguageProvider.self] = newValue }
    }
}

extension AppLanguageProvider: DependencyKey {
    public static let liveValue: any AppLanguageProviding = AppLanguageProvider()
}

public protocol AppLanguageProviding: Sendable {
    var current: AppLanguage { get }
}

struct AppLanguageProvider: AppLanguageProviding {
    var current: AppLanguage {
        .current()
    }
}
