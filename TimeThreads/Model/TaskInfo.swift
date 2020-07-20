//
//  TaskInfo.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/19.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct TaskInfo: Codable {
    // MARK: - editable
    var label: String? = nil
    var estimatedTime: Time? = nil
    
    // MARK: - computed
    var done: Bool = false
    var progress: Double = 0.0
}
