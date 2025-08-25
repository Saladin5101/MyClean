// MyClean - Test
// Copyright (C) 2020 Saladin5101
//
// This file is part of MyClean, released under the GNU General Public License v3.0 (GPLv3).
// See LICENSE for full license terms and COPYING for copyright details.
import XCTest
@testable import MyClean
import Foundation

class MyCleanTests: XCTestCase {
    func testCacheCleaning()throws {
        if #available(macOS 15.0, *) {
            guard let testDir = CacheCleaner.getAppCacheDirectory() else {
                XCTFail("无法获取应用缓存目录")
                return
            }
            
            let testFile = testDir.appendingPathComponent("test_cache.txt")
            
            // 创建测试文件（可能抛出错误，必须用 try 并处理）
            do {
                // 修复：添加 try 标记可能抛出的调用
                try "test".write(to: testFile, atomically: true, encoding: .utf8)
                XCTAssertTrue(FileManager.default.fileExists(atPath: testFile.path), "测试文件应被创建")
            } catch {
                XCTFail("创建测试文件失败: \(error)")
                return // 失败后终止测试
            }
            
            // 测试清理功能
            let result = CacheCleaner.cleanAllCache()
            
            // 检查清理结果
            if case .success = result {
                // 验证文件已删除（删除操作可能抛出错误，需处理）
                do {
                    // 尝试检查文件是否存在（虽然不抛出，但如果需要删除残留文件，需用 try）
                    if FileManager.default.fileExists(atPath: testFile.path) {
                        // 若未删除，手动删除并报错
                        try FileManager.default.removeItem(at: testFile) // 修复：添加 try
                        XCTFail("缓存清理未删除测试文件，已手动清理")
                    }
                } catch {
                    XCTFail("验证文件删除时出错: \(error)")
                }
            } else {
                XCTFail("缓存清理失败")
            }
        } else {
            throw XCTSkip("本测试仅支持 macOS 15.0 及以上版本")
        }
    }
}
