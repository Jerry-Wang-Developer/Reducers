//
//  File.swift
//  
//
//  Created by 王小涛 on 2024/7/20.
//

import Foundation
import MobileCore
import Dependencies

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

