// AppLanguage.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/4/30.

import Foundation

public enum AppLanguage: String {
    case zh_Hans
    case zh_Hant
    case en

    // 无论是通过App本身的设置语言，还是通过系统设置里面的地区和语言修改语言，这里都可以得到正确的语言设置。
    public static func current() -> Self {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return .en
        }
        let locale = Locale(identifier: preferredLanguage)

        guard let languageCode = locale.language.languageCode else {
            return .en
        }
        let script = locale.language.script

        if languageCode == .english {
            return .en
        } else if languageCode == .chinese {
            if script == .hanTraditional {
                return .zh_Hant
            } else {
                return .zh_Hans
            }
        }

        return .en
    }
}

extension AppLanguage {
    public var isChinese: Bool {
        self == .zh_Hant || self == .zh_Hans
    }
}
