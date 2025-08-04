//
//  MyCleanApp.swift
//  MyClean
//
//  Created by minmin on 2025/1/14.
//
//2


import Foundation
import Cocoa
// Define a function to clear old cache files

class AppDelegate: NSObject, NSApplicationDelegate {
    func clearOldCacheFiles(folderURL: URL, olderThan days: Double) {
        let fileManager = FileManager.default
        let cutoffDate = Date(timeIntervalSinceNow: -days * 24 * 60 * 60) // Calculate the time threshold
            
        do {
            let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)
                
            for url in contents {
                let resourceValues = try url.resourceValues(forKeys: [.contentModificationDateKey])
                if let modificationDate = resourceValues.contentModificationDate, modificationDate < cutoffDate {
                        // The file was modified before the threshold, it can be deleted
                    try fileManager.removeItem(at: url)
                    print("Deleted old file: \(url.lastPathComponent)")
                    }
                }
            } catch {
                print("Error occurred while clearing cache: \(error)")
            }
        }
        
        // Call the function from a main entry point
        func main() {
            if #available(macOS 15.0, *) {
                let folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                clearOldCacheFiles(folderURL: folderURL, olderThan: 30) // 清理30天前的缓存文件
            } else {
                // Fallback on earlier versions
            }
        }
    }


//LOg
//
//  see_the_error.swift
//  MyClean
//
//  Created by minmin on 2025/2/4.
//
import OSLog
import Foundation
import os.log





struct Logger {

    static let customLog = OSLog(
        subsystem: "com.earth.debug",
        category: "debug"
    )
    

    static func logDebug(_ message: String) {
        os_log("%@", log: .default, type: .debug, message)
    }
    

    static func logError(_ message: String) {
        os_log("%@", log: customLog, type: .error, message)
    }
    
}


func runDebug(){
    Logger.logDebug("This is a debug message.")
    Logger.logError("An error occurred!")
    
}

runDebug()
