import XCTest
@testable import MyClean
import Foundation

class MyCleanTests: XCTestCase {
    func testCacheDirectoryAccess() {
        // 测试能否正确获取应用缓存目录
        let cacheDir = CacheCleaner.getAppCacheDirectory()
        XCTAssertNotNil(cacheDir, "应用缓存目录不应为nil")
    }
    
    func testCacheCleaning() {
        // 创建测试文件
        guard let testDir = CacheCleaner.getAppCacheDirectory() else {
            XCTFail("无法获取应用缓存目录")
            return
        }
        
        let testFile = testDir.appendingPathComponent("test_cache.txt")
        
        // 创建测试文件
        do {
            try "test".write(to: testFile, atomically: true, encoding: .utf8)
            XCTAssertTrue(FileManager.default.fileExists(atPath: testFile.path), "测试文件应被创建")
            
            // 测试清理功能
            let success = CacheCleaner.clearAllCacheFiles()
            XCTAssertTrue(success, "缓存清理应成功")
            XCTAssertFalse(FileManager.default.fileExists(atPath: testFile.path), "测试文件应被删除")
        } catch {
            XCTFail("测试过程中发生错误: \(error)")
        }
    }
}
