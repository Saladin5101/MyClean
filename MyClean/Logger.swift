import OSLog

// 定义日志子系统
private let cacheCleaner = OSLog(subsystem: "com.example.MyClean", category: "CacheCleaner")

enum Logger {
    static func logError(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .error, message)
    }
    
    static func logInfo(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .info, message)
    }
}
