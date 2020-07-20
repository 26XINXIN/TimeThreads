//
//  SubTask.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/18.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation


struct SubTask: Identifiable, Codable {
    private(set) var info: TaskInfo
    private(set) var parentID: String
    var id: String = UUID().uuidString
    
    init(info: TaskInfo, parentID: String) {
        self.info = info
        self.parentID = parentID
    }
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    mutating func update(info: TaskInfo) {
        self.info = info
    }
    
    mutating func done() {
        info.done = true
        info.progress = 100
    }
    
    mutating func undone() {
        info.done = false
        info.progress = 0
    }
}
