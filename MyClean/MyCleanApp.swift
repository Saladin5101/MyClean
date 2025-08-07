import SwiftUI
import Cocoa

class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(nil)
    }
}

@main
struct MyCleanApp: App {
    private let windowDelegate = WindowDelegate()
    
    init() {
        createWindowManually()
    }
    
    var body: some Scene {
        EmptyScene()
    }
    
    private func createWindowManually() {
        let window = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.delegate = windowDelegate
        window.title = "MyClean"
        window.center()
        
        // 加载ContentView作为窗口内容（替换空容器）
        if #available(macOS 15.0, *) {
            window.contentView = NSHostingView(rootView: ContentView())
        } else {
            window.contentView = NSHostingView(rootView: Text("不支持当前系统版本"))
        }
        
        window.makeKeyAndOrderFront(nil)
    }
}

struct EmptyScene: Scene {
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}
