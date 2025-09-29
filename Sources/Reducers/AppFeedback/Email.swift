import ApplicationDependency
import ComposableArchitecture
import DeviceKit
import Foundation
import MobileCore
import UIKit

public struct Email: Sendable {
    let to: String
    let cc: String?
    let subject: String?
    let body: String?

    public init(draft: AppFeedbackDraft) async {
        self = await draft.email
    }

    init(
        to: String,
        cc: String? = nil,
        subject: String? = nil,
        body: String? = nil
    ) {
        self.to = to
        self.cc = cc
        self.subject = subject
        self.body = body
    }
}

public struct AppFeedbackDraft: Sendable {
    let appName: String
    let to: String
    let cc: String?

    public init(
        appName: String,
        to: String = "leohuang.ux@gmail.com",
        cc: String? = "jerryxtwang@gmail.com"
    ) {
        self.appName = appName
        self.to = to
        self.cc = cc
    }

    var email: Email {
        get async {
            let subject = "\(appName) App Feedback"
            
            let body = """
        
        
        
        
        
        
        ---------------------------------
        Device: \(Device.current)
        iOS Version: \(await systemVersion)
        Locale: \(Locale.current.identifier)
        Timezone: \(TimeZone.current.identifier)
        App Version: \(Bundle.main.bundleShortVersion ?? "")
        App Build Version: \(Bundle.main.bundleVersion ?? "")
        App Language: \(AppLanguage.current().rawValue)
        """
            
            return .init(
                to: to,
                cc: cc,
                subject: subject,
                body: body
            )
        }
    }
    
    var systemVersion: String {
        get async {
            await Task { @MainActor in
                UIDevice.current.systemVersion
            }.value
        }
    }
}

//public extension Application {
//    @MainActor @discardableResult
//    func send(email: Email) async -> Bool {
//        if let url: URL = .system.email(
//            to: email.to,
//            cc: email.cc,
//            subject: email.subject,
//            body: email.body
//        ) {
//            return await open(url)
//        }
//        return false
//    }
//}
