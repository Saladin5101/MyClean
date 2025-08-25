// MyClean - Main exit
// Copyright (C) 2020 Saladin5101
//
// This file is part of MyClean, released under the GNU General Public License v3.0 (GPLv3).
// See LICENSE for full license terms and COPYING for copyright details.
// <https://www.gnu.org/licenses/gpl-3.0.html>
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
