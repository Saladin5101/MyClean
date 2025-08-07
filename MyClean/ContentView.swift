import SwiftUI

@available(macOS 15.0, *)
struct ContentView: View {
    @State private var isCleaning = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("MyClean")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("清理应用缓存，释放存储空间")
                .foregroundColor(.secondary)
            
            Button(action: cleanCache) {
                if isCleaning {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Text("清理所有缓存")
                        .padding()
                }
            }
            .disabled(isCleaning)
            .frame(width: 200)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("操作结果"), message: Text(alertMessage), dismissButton: .default(Text("确定")))
            }
            
            // 增加缓存目录显示
            if let cacheDir = CacheCleaner.getAppCacheDirectory() {
                Text("缓存目录: \(cacheDir.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .background(Color.yellow.opacity(0.1))
    }
    
    private func cleanCache() {
        isCleaning = true
        
        DispatchQueue.global().async {
            let result = CacheCleaner.cleanAllCache()
            
            DispatchQueue.main.async {
                isCleaning = false
                switch result {
                case .success:
                    alertMessage = "缓存清理成功！已跳过系统关键目录"
                case .failure(let error):
                    alertMessage = "缓存清理失败：\(error.localizedDescription)"
                }
                showAlert = true
            }
        }
    }
}

@available(macOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
