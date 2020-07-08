//
//  TaskInfo.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct TaskTree {
    var rootTask: TaskInfo
    
    func preOrderTraverse(rooted root: TaskInfo) -> [TaskInfo] {
        root.preOrderTraverse()
    }
    
    func findTaskNode(id: String) -> TaskInfo? {
        findTaskNode(id: id, root: rootTask)
    }
    
    private func findTaskNode(id: String, root: TaskInfo) -> TaskInfo? {
        if root.id == id {
            return root
        }
        for subTask in root.subTasks {
            if let found = findTaskNode(id: id, root: subTask) {
                return found
            }
        }
        return nil
    }
    
    static func generateTestTask() -> TaskTree {
        let task = TaskInfo(id: UUID().uuidString, label: "main task", level: 0)
        let subTask1 = TaskInfo(id: UUID().uuidString, label: "sub task 1", level: 1)
        subTask1.addSubTask(task: TaskInfo(id: UUID().uuidString, label: "sub sub task 1"))
        task.addSubTask(task: subTask1)
        task.addSubTask(task: TaskInfo(id: UUID().uuidString, label: "sub task 2"))
        return TaskTree(rootTask: task)
    }
}

class TaskInfo: Identifiable, Codable {
    var id: String
    private(set) var label: String
    var subTasks: Array<TaskInfo> = []
    private(set) var level = 0
    private(set) var parentID: String?
    
    // MARK: - initializers
    
    init(id: String, label: String, subTask: Array<TaskInfo> = [], level: Int = 0){
        self.id = id
        self.label = label
        self.subTasks = subTask
        self.level = level
    }
    
    static func copy(from other: TaskInfo, rootLevel: Int = 0) -> TaskInfo {
        let root = TaskInfo(id: other.id, label: other.label, level: rootLevel)
        for subTask in other.subTasks {
            root.addSubTask(task: TaskInfo.copy(from: subTask, rootLevel: rootLevel + 1))
        }
        return root
    }
    
    // MARK: - tree operations
    
    func addSubTask(task: TaskInfo) {
        task.setLevel(level: level + 1)
        task.parentID = id
        subTasks.append(task)
    }
    
    func addSubTask(_ newTask: TaskInfo, after node: TaskInfo) {
        newTask.setLevel(level: level + 1)
        newTask.parentID = id
        if let found = subTasks.firstIndex(where: { element in element.id == node.id}) {
            subTasks.insert(newTask, at: found + 1)
        } else {
            print("precedence node not found: \(node.id)")
        }
    }
    
    func addSubTask(_ newTask: TaskInfo, before node: TaskInfo) {
        newTask.setLevel(level: level + 1)
        newTask.parentID = id
        if let found = subTasks.firstIndex(where: { element in element.id == node.id}) {
            subTasks.insert(newTask, at: found)
        } else {
            print("successor node not found: \(node.id)")
        }
    }
    
    func removeSubTask(_ task: TaskInfo) {
        if let index = subTasks.firstIndex(where: {subTask in subTask.id == task.id}) {
            subTasks.remove(at: index)
        } else {
            print("Error: not finding deleted node in parent's subTask array")
        }
    }
    
    func preOrderTraverse() -> Array<TaskInfo> {
        var taskList = [self]
        for subTask in subTasks {
            taskList.append(contentsOf: subTask.preOrderTraverse())
        }
        return taskList
    }
    
    // MARK: - setters
    
    func setLevel(level: Int) {
        self.level = level
        for task in subTasks {
            task.setLevel(level: level + 1)
        }
    }
    
    
    
    var asJson: Data? {
        try? JSONEncoder().encode(self)
    }
}
