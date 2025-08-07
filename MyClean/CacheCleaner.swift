import Foundation

enum CacheError: Error, LocalizedError {
    case invalidDirectory
    case cleaningFailed
    case permissionDenied
    
    var localizedDescription: String {
        switch self {
        case .invalidDirectory: return "无效的缓存目录"
        case .cleaningFailed: return "缓存清理失败"
        case .permissionDenied: return "没有权限访问缓存目录"
        }
    }
}

enum CacheCleaner {
    /// 获取应用缓存目录（~/Library/Caches）
    static func getAppCacheDirectory() -> URL? {
        guard let homeDir = FileManager.default.homeDirectoryForCurrentUser as URL? else {
            return nil
        }
        return homeDir.appendingPathComponent("Library/Caches", isDirectory: true)
    }
    
    /// 清理所有缓存
    static func cleanAllCache() -> Result<Void, CacheError> {
        guard let cacheDir = getAppCacheDirectory() else {
            return .failure(.invalidDirectory)
        }
        
        // 检查目录是否可访问
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: cacheDir.path, isDirectory: &isDir), isDir.boolValue else {
            return .failure(.invalidDirectory)
        }
        
        do {
            // 获取目录下所有内容
            let contents = try FileManager.default.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
            
            for item in contents {
                // 跳过系统关键目录（避免误删）
                let skipDirs = ["com.apple", "system"]
                if skipDirs.contains(where: { item.lastPathComponent.hasPrefix($0) }) {
                    continue
                }
                
                // 删除项目
                try FileManager.default.removeItem(at: item)
            }
            return .success(())
        } catch let error as NSError where error.code == NSFileWriteNoPermissionError {
            return .failure(.permissionDenied)
        } catch {
            return .failure(.cleaningFailed)
        }
    }
}
