// MyClean - Log repoter
// Copyright (C) 2020 Saladin5101
//
// This file is part of MyClean, released under the GNU General Public License v3.0 (GPLv3).
// See LICENSE for full license terms and COPYING for copyright details.
// <https://www.gnu.org/licenses/gpl-3.0.html>
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
