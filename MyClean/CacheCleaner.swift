import Foundation

// 修复：统一版本兼容性
@available(macOS 14.0, *)
enum CacheCleaner {
    // 清理所有缓存
    static func cleanAllCache() -> Result<Void, Error> {
        guard let appCacheDir = getAppCacheDirectory() else {
            return .failure(CacheError.invalidDirectory)
        }
        
        return deleteContents(of: appCacheDir)
    }
    
    // 清理指定天数前的缓存
    static func clearOldCacheFiles(olderThan days: Int) {
        guard let appCacheDir = getAppCacheDirectory() else {
            logError("无法获取应用缓存目录")
            return
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: appCacheDir, includingPropertiesForKeys: [.contentModificationDateKey])
            
            for file in files {
                let attributes = try file.resourceValues(forKeys: [.contentModificationDateKey])
                if let modificationDate = attributes.contentModificationDate, modificationDate < cutoffDate {
                    do {
                        try FileManager.default.removeItem(at: file)
                        logInfo("已删除过期缓存: \(file.lastPathComponent)")
                    } catch {
                        logError("删除文件失败 \(file.lastPathComponent): \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            logError("获取缓存文件列表失败: \(error.localizedDescription)")
        }
    }
    
    // 获取应用专属缓存目录
    private static func getAppCacheDirectory() -> URL? {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            logError("无法获取应用Bundle ID")
            return nil
        }
        
        guard let systemCacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            logError("无法获取系统缓存目录")
            return nil
        }
        
        let appCacheDir = systemCacheDir.appendingPathComponent(bundleId)
        
        // 修复：确保目录存在，如果不存在则创建
        if !FileManager.default.fileExists(atPath: appCacheDir.path) {
            do {
                try FileManager.default.createDirectory(at: appCacheDir, withIntermediateDirectories: true)
                logInfo("创建应用缓存目录: \(appCacheDir.path)")
            } catch {
                logError("创建应用缓存目录失败: \(error.localizedDescription)")
                return nil
            }
        }
        
        return appCacheDir
    }
    
    // 递归删除目录内容
    private static func deleteContents(of directory: URL) -> Result<Void, Error> {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            
            for item in contents {
                do {
                    try FileManager.default.removeItem(at: item)
                    logInfo("已删除: \(item.lastPathComponent)")
                } catch {
                    logError("删除项目失败 \(item.lastPathComponent): \(error.localizedDescription)")
                    // 继续删除其他项目，不因单个项目失败而中断
                }
            }
            return .success(())
        } catch {
            logError("获取目录内容失败: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    // 日志工具
    private static func logInfo(_ message: String) {
        Logger.logInfo("[CacheCleaner] \(message)")
    }
    
    private static func logError(_ message: String) {
        Logger.logError("[CacheCleaner] \(message)")
    }
}

// 修复：添加错误类型枚举
enum CacheError: Error, LocalizedError {
    case invalidDirectory
    
    var errorDescription: String? {
        switch self {
        case .invalidDirectory:
            return "无效的缓存目录"
        }
    }
}
    
