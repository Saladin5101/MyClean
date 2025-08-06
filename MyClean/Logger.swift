// Logger.swift
import OSLog
import Foundation

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.earth.MyClean"
    private static let cacheCleaner = OSLog(subsystem: subsystem, category: "CacheCleaner")
    
    static func logInfo(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .info, message)
    }
    
    static func logError(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .error, message)
    }
    
    static func logDebug(_ message: String) {
        #if DEBUG
        os_log("%@", log: cacheCleaner, type: .debug, message)
        #endif
    }
}
