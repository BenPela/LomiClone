//
//  Analytics.swift
//  Lomi
//
//  Created by Peter Harding on 2022-03-21.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsLogging {
    func logEvent(_ event: AnalyticsEvent, parameters: [AnalyticsParam: String]?) -> Void
}

/// to allow parameters to have a default argument of nil
extension AnalyticsLogging {
    func logEvent(_ event: AnalyticsEvent) {
        logEvent(event, parameters: nil)
    }
}

enum AnalyticsEvent: String {
    /// predefined events
    case screenView
    case signUp
    case login
    /// custom events
    case registrationAdd
    case registrationDelete
    case registrationUpdate
    case onboardingVideoSkip
    case onboardingVideoComplete
    case logout
    case userUpdate
    case openUrl

    var rawValue: String {
        switch self {
        /// predefined events
        case .screenView:
            return AnalyticsEventScreenView
        case .signUp:
            return AnalyticsEventSignUp
        case .login:
            return AnalyticsEventLogin
        /// custom events
        case .registrationAdd:
            return "registration_add"
        case .registrationDelete:
            return "registration_delete"
        case .registrationUpdate:
            return "registration_update"
        case .onboardingVideoSkip:
            return "onboarding_video_skip"
        case .onboardingVideoComplete:
            return "onboarding_video_complete"
        case .logout:
            return "log_out"
        case .userUpdate:
            return "user_update"
        case .openUrl:
            return "open_url"
        }
    }
}

enum AnalyticsParam: String {
    case screenName
    case itemVariant
    case itemCategory
    case itemID
    case itemName
    case source
    case method
    /// custom params
    case linkURL

    var rawValue: String {
        switch self {
        case .screenName:
            return AnalyticsParameterScreenName
        case .itemVariant:
            return AnalyticsParameterItemVariant
        case .itemCategory:
            return AnalyticsParameterItemCategory
        case .itemID:
            return AnalyticsParameterItemID
        case .itemName:
            return AnalyticsParameterItemName
        case .source:
            return AnalyticsParameterSource
        case .method:
            return AnalyticsParameterMethod
        /// custom params
        case .linkURL:
            return "link_url"
        }
    }
}

/// https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
class AnalyticsLogger: AnalyticsLogging {
    // static variables are lazy loaded by default, so no need to manually check that there is only
    // one instance of AnalyticsLogger
    static var singleton: AnalyticsLogging = {
        let instance = AnalyticsLogger()
        return instance
    }()

    // prevents incorrect manual intialization without using the singleton
    private init() {}

    func logEvent(_ event: AnalyticsEvent, parameters: [AnalyticsParam: String]?) {
        // prefer guard to unwrapping the optional here to match the sending of nil instead of [:] to Analytics
        guard let gParams = parameters else {
            return Analytics.logEvent(event.rawValue, parameters: nil)
        }
        // convert the enum keys to their string values
        let keyTransform = Dictionary(uniqueKeysWithValues: gParams.map { ($0.rawValue, $1) })
        Analytics.logEvent(event.rawValue, parameters: keyTransform)
    }
}
