import SwiftUI
// 恢复@main标记作为应用入口
//@main
struct MyCleanApp: App {
    // 关联AppDelegate以处理生命周期事件
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// 实现AppDelegate处理应用生命周期事件
/*class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 应用启动后清理旧缓存
        CacheCleaner.clearOldCacheFiles()
    }
}*/
