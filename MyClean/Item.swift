// Item.swift
import SwiftData
import Foundation

@available(macOS 15.0, *)
@Model
class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
