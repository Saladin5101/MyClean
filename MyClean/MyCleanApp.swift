// MyCleanApp.swift
import SwiftUI
import SwiftData
import Cocoa
@available(macOS 15.0, *)
@main // 唯一入口

@available(macOS 15.0, *)
class AppDelegate: NSObject, NSApplicationDelegate {
    // 应用启动后自动清理30天前的缓存
    func applicationDidFinishLaunching(_ notification: Notification) {
        CacheCleaner.clearOldCacheFiles(olderThan: 30)
    }
}

struct MyCleanApp: App {
    // 关联AppDelegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
