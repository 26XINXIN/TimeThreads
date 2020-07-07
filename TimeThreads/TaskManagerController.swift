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
    
    // MARK: - Intents
    
    func addSiblingTask(_ newTask: TaskInfo, after node: TaskInfo) {
        print("adding new task")
        if node.parentID == nil {
            print("Adding task on root level: not allowed")
            return
        }
        let parent = task.findTaskNode(id: node.parentID!)
        if parent == nil {
            print("Parent task not found: \(node.parentID!)")
        } else {
            parent!.addSubTask(newTask, after: node)
        }
        
        // TODO: bad change signal
        objectWillChange.send()
    }
}
