//
//  States.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/18.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct TaskState: Codable {
    var expanded: Bool = false
    var editing: Bool = false
    var newlyAdded: Bool = false
    var finished: Bool = false
}
