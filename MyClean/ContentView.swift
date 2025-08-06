// ContentView.swift
import SwiftUI

@available(macOS 15.0, *)
struct ContentView: View {
    @State private var isCleaning = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MyClean")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("清理您应用的缓存文件，释放存储空间")
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
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
    
    private func cleanCache() {
        isCleaning = true
        
        // 后台线程执行清理
        DispatchQueue.global().async {
            let result = CacheCleaner.cleanAllCache()
            
            // 主线程更新UI
            DispatchQueue.main.async {
                isCleaning = false
                switch result {
                case .success:
                    alertMessage = "缓存清理成功！"
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
