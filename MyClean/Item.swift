import SwiftData

// 调整最低版本要求以匹配应用支持的版本
@available(macOS 15.0, *)
@Model
class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
