import OSLog

// 确保整个项目中只有这一个Logger结构体
struct Logger {
    // 使用应用的Bundle ID作为日志subsystem，更规范
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.earth.MyClean"
    
    // 定义日志类别
    private static let cacheCleaner = OSLog(subsystem: subsystem, category: "CacheCleaner")
    
    // 信息级别日志
    static func logInfo(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .info, message)
    }
    
    // 错误级别日志
    static func logError(_ message: String) {
        os_log("%@", log: cacheCleaner, type: .error, message)
    }
    
    // 调试级别日志（仅在DEBUG模式下生效）
    static func logDebug(_ message: String) {
        #if DEBUG
        os_log("%@", log: cacheCleaner, type: .debug, message)
        #endif
    }
}
