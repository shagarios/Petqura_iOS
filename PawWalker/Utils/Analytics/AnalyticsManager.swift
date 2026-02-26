//
//  AnalyticsManager.swift
//  PawWalker
//
//  Created by shagar on 31/10/24.
//

protocol AnalyticsManagerProtocol {
    func logEvent(event : EventProtocol)
}
protocol EventProtocol {
    var name : String {get}
    var param : [String : Any] {get}
}
struct Event : EventProtocol {
    var name : String
    var param : [String : Any] = [:]
}
protocol AnalyticsEventLoggerProtocol {
    func initialize()
    func logEvent(event: EventProtocol)
}

final class AnalyticsManager : AnalyticsManagerProtocol {
    private let logger : AnalyticsEventLoggerProtocol
    init(logger: AnalyticsEventLoggerProtocol) {
        self.logger = logger
    }
    func logEvent(event: EventProtocol) {
        logger.logEvent(event: event)
    }
}

enum AnalyticEvents {
    case clickButtonTapped
    case chapterTapped(name : String)
}

extension AnalyticEvents : EventProtocol {
    var name: String {
        switch self {
        case .clickButtonTapped:
            return "click_button_tapped"
        case .chapterTapped(let name):
            return "chapter_tapped"
        }
    }
    var param: [String : Any] {
        switch self {
        case .clickButtonTapped:
            return [:]
        case .chapterTapped(let name):
            return ["name" : name]
        }
    }
    
    
}
