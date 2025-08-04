//
//  Item.swift
//  MyClean
//
//  Created by minmin on 2025/1/14.
//

import Foundation
import SwiftData
import SwiftUI
//OS if else
let osVersion = ProcessInfo.processInfo.operatingSystemVersion
@available(macOS 15.0, *)//此处被更改
    @Model
    final class Item {
        var timestamp: Date
        
        init(timestamp: Date) {
            self.timestamp = timestamp
        }
    }

