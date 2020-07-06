//
//  TaskManagerController.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

class TaskManagerController: ObservableObject {
    @Published private var task = TaskTree.generateTestTask()
    
    // MARK: - Access to Data
    
    func listTasks() -> Array<TaskInfo> {
        let taskList = task.preOrderTraverse()
        print("\(taskList)")
        return taskList
    }
}
