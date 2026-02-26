//
//  FirbaseAnalaticManager.swift
//  PawWalker
//
//  Created by shagar on 31/10/24.
//

import Foundation
import FirebaseAnalytics


class FirbaseAnalyticsManager : AnalyticsEventLoggerProtocol {
    func initialize() {}
    func logEvent(event: EventProtocol) {
        Analytics.logEvent(event.name, parameters: event.param)
    }
}
