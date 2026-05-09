// System+URL.swift
// Copyright (c) 2026 Nostudio Office
// Created by Jerry X T Wang on 2025/4/30.

import Foundation
import UIKit

extension System where Base == URL {
    public static let appSettings: Base = .init(string: UIApplication.openSettingsURLString)!
    public static let settings: Base = .init(string: "App-Prefs:root=General")!

    public static func appstorePage(appID: String) -> Base {
        .init(string: "https://itunes.apple.com/app/id\(appID)")!
    }

    public static func appstoreReviewPage(appID: String) -> Base {
        .init(string: "https://itunes.apple.com/app/id\(appID)?action=write-review")!
    }

    public static func email(to: String,
                             cc: String? = nil,
                             subject: String? = nil,
                             body: String? = nil) -> Base?
    {
        var components = URLComponents(string: "mailto:\(to)")

        let ccItem = URLQueryItem(name: "cc", value: cc)
        let subjectItem = URLQueryItem(name: "subject", value: subject)
        let bodyItem = URLQueryItem(name: "body", value: body)

        components?.queryItems = [
            ccItem,
            subjectItem,
            bodyItem,
        ]

        return components?.url
    }

    static func url(_ string: String) -> URL {
        .init(string: string)!
    }
}

extension URL: SystemCompatible {}
