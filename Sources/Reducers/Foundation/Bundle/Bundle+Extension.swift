// Bundle+Extension.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/4/30.

import Foundation

extension Bundle {
    public var localizedBundleDisplayName: String? {
        localizedInfoDictionary?["CFBundleDisplayName"] as? String
    }
}

extension Bundle {
    public var bundleShortVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public var bundleVersion: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
