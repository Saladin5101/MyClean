// CacheCleaner.swift
import Foundation

// 统一版本要求
@available(macOS 15.0, *)
enum CacheCleaner {
    // 错误类型定义（只保留这一个，删除重复定义）
    enum CacheError: Error, LocalizedError {
        case invalidDirectory
        case cleaningFailed
        
        var localizedDescription: String {
            switch self {
            case .invalidDirectory: return "无效的缓存目录"
            case .cleaningFailed: return "缓存清理失败"
            }
        }
    }
    
    // 清理所有缓存（返回Result类型）
    static func cleanAllCache() -> Result<Void, CacheError> {
        guard let appCacheDir = getAppCacheDirectory() else {
            return .failure(.invalidDirectory)
        }
        
        return deleteContents(of: appCacheDir) ? .success(()) : .failure(.cleaningFailed)
    }
    
    // 清理指定天数前的缓存
    static func clearOldCacheFiles(olderThan days: Int) {
        guard let appCacheDir = getAppCacheDirectory() else {
            Logger.logError("无法获取应用缓存目录")
            return
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        
        do {
            // 修复：明确指定URLResourceKey类型
            let files = try FileManager.default.contentsOfDirectory(
                at: appCacheDir,
                includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey]
            )
            
            for file in files {
                // 修复：明确指定URLResourceKey类型
                let attributes = try file.resourceValues(forKeys: [URLResourceKey.contentModificationDateKey])
                if let modificationDate = attributes.contentModificationDate, modificationDate < cutoffDate {
                    do {
                        try FileManager.default.removeItem(at: file)
                        Logger.logInfo("已删除过期缓存: \(file.lastPathComponent)")
                    } catch {
                        Logger.logError("删除文件失败 \(file.lastPathComponent): \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            Logger.logError("获取缓存文件列表失败: \(error.localizedDescription)")
        }
    }
    
    // 修复：修正函数定义（删除错误的CacheError重复定义）
    // CacheCleaner.swift 中修改
    static func getAppCacheDirectory() -> URL? {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            Logger.logError("无法获取Bundle ID")
            return nil
        }
        // 确保是用户级缓存目录（~/Library/Caches/[bundleID]）
        guard let systemCacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            Logger.logError("无法获取用户缓存目录")
            return nil
        }
        let appCacheDir = systemCacheDir.appendingPathComponent(bundleId)
        
        // 确保目录存在（修复可能的权限问题）
        do {
            try FileManager.default.createDirectory(at: appCacheDir, withIntermediateDirectories: true, attributes: [
                FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication
            ])
            Logger.logInfo("创建用户级缓存目录: \(appCacheDir.path)")
        } catch {
            Logger.logError("创建缓存目录失败: \(error)")
            return nil
        }
        return appCacheDir
    }
    
    // 递归删除目录内容
    private static func deleteContents(of directory: URL) -> Bool {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            for item in contents {
                do {
                    try FileManager.default.removeItem(at: item)
                    Logger.logInfo("已删除: \(item.lastPathComponent)")
                } catch {
                    Logger.logError("删除项目失败 \(item.lastPathComponent): \(error.localizedDescription)")
                }
            }
            return true
        } catch {
            Logger.logError("获取目录内容失败: \(error.localizedDescription)")
            return false
        }
    }
}
