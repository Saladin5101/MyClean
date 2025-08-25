// MyClean - Save Data
// Copyright (C) 2020 Saladin5101
//
// This file is part of MyClean, released under the GNU General Public License v3.0 (GPLv3).
// See LICENSE for full license terms and COPYING for copyright details.
// <https://www.gnu.org/licenses/gpl-3.0.html>
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
