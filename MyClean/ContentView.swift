//  ContentView.swift
//  MyClean
//
//  Created by minmin on 2025/1/14.
//

import SwiftUI

struct ContentView: View {
    @State private var isDeleting = false
    @State private var deleteStatus: String?  // 用于显示操作结果
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Clear Cache") {
                isDeleting = true
                deleteStatus = nil
                // 在后台线程执行删除操作，避免阻塞UI
                DispatchQueue.global().async {
                    let success = deleteCacheFiles()
                    // 回到主线程更新UI
                    DispatchQueue.main.async {
                        isDeleting = false
                        deleteStatus = success ? "Cache cleared successfully!" : "Failed to clear cache."
                    }
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isDeleting)
            
            // 显示加载状态或结果
            if isDeleting {
                Text("Deleting cache files...")
                    .foregroundColor(.gray)
            } else if let status = deleteStatus {
                Text(status)
                    .foregroundColor(status.contains("successfully") ? .green : .red)
            }
        }
        .frame(minWidth: 300, minHeight: 150)
        .padding()
    }
    
    /// 删除缓存文件（仅删除应用沙盒内的缓存，避免系统文件）
    private func deleteCacheFiles() -> Bool {
        // 获取当前应用的缓存目录（更安全，仅操作应用自身缓存）
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return false
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: cacheURL,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]  // 跳过隐藏文件，避免系统保护文件
            )
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            print("Cache files deleted successfully.")
            return true
        } catch {
            print("Could not delete cache files: \(error.localizedDescription)")
            return false
        }
    }
}

// 预览提供者（保持简洁，避免干扰预览）
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
