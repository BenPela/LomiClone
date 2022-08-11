//
//  Logger.swift
//  Lomi
//
//  Created by Peter Harding on 2022-05-05.
//

import os
import Foundation

protocol Logging {
    // There is no specific way to force protocol to have inner struct or class. But this makes protocol to have or use some type which conforms to `LoggingOperations`
    associatedtype log: LoggingOperations
}

protocol LoggingOperations {
    associatedtype T
    static func info(tag: T, messages: String...)
    static func debug(tag: T, messages: String...)
    static func error(tag: T, messages: String...)
    static func warning(tag: T, messages: String...)
}

// Swift has a Logger class as of iOS 14 https://developer.apple.com/documentation/os/logger
// we provide a static wrapper so that we don't need to inject SystemLogger everywhere
struct SystemLogger: Logging {
    
    struct log: LoggingOperations {
        
        /// Use this level to capture information that may be useful during development or while troubleshooting a specific problem.
        static func debug(tag: TAG = .systemDefault, messages: String...) {
            // `Logger` is pretty optimized and cheap to call. There is no performance issue even we construct a new logger each time.
            let logger = Logger(subsystem: AppConfig.identifier, category: tag.rawValue)
            for message in messages {
                logger.debug("\(message)")
            }
        }
        
        /// Use this level to capture information that may be helpful, but not essential, for troubleshooting errors.
        static func info(tag: TAG = .systemDefault, messages: String...) {
            let logger = Logger(subsystem: AppConfig.identifier, category: tag.rawValue)
            for message in messages {
                logger.info("\(message)")
            }
        }
        
        /// Show possible issues that are not yet errors.
        ///
        /// We use the [ `default`](https://developer.apple.com/documentation/os/oslogtype/2320721-default) level which looks equivalent to Android's [`warning`](https://developer.android.com/studio/debug/am-logcat#level).
        /// Strangely, [`logger.warning`](https://developer.apple.com/documentation/os/logger/3551625-warning) is just an alias of `error` at Swift.
        static func warning(tag: TAG = .systemDefault, messages: String...) {
            let logger = Logger(subsystem: AppConfig.identifier, category: tag.rawValue)
            for message in messages {
                logger.log(level: .default, "\(message)")
            }
        }
        
        /// Use this log level to report process-level errors.
        static func error(tag: TAG = .systemDefault, messages: String...) {
            let logger = Logger(subsystem: AppConfig.identifier, category: tag.rawValue)
            for message in messages {
                logger.error("\(message)")
            }
        }

    }
}


// TAG
extension SystemLogger {
    enum TAG: String {
        case systemDefault = ""
        case coreData = "CORE_DATA"
        case auth = "AUTH"
    }
}
