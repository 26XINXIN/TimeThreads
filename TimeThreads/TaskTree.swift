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
    
    func preOrderTraverse() -> [TaskInfo] {
        rootTask.preOrderTraverse()
    }
    
    func findTaskNode(id: String) -> TaskInfo? {
        findTaskNode(id: id, root: rootTask)
    }
    
    private func findTaskNode(id: String, root: TaskInfo) -> TaskInfo? {
        if root.id == id {
            return root
        }
        if root.subTasks != nil {
            for subTask in root.subTasks! {
                if let found = findTaskNode(id: id, root: subTask) {
                    return found
                }
            }
        }
        return nil
    }
    
    static func generateTestTask() -> TaskTree {
        let task = TaskInfo(id: UUID().uuidString, label: "main task", subTask: nil, level: 0)
        let subTask1 = TaskInfo(id: UUID().uuidString, label: "sub task 1", subTask: nil, level: 1)
        subTask1.addSubTask(task: TaskInfo(id: UUID().uuidString, label: "sub sub task 1", subTask: nil, level: 0))
        task.addSubTask(task: subTask1)
        task.addSubTask(task: TaskInfo(id: UUID().uuidString, label: "sub task 2", subTask: nil, level: 0))
        return TaskTree(rootTask: task)
    }
}

class TaskInfo: Identifiable, Codable {
    var id: String
    private(set) var label: String
    var subTasks: Array<TaskInfo>?
    private(set) var level = 0
    private(set) var parentID: String?
    
    init(id: String, label: String, subTask: Array<TaskInfo>?, level: Int){
        self.id = id
        self.label = label
        self.subTasks = subTask
        self.level = level
    }
    
    static func copy(from other: TaskInfo, rootLevel: Int = 0) -> TaskInfo {
        let root = TaskInfo(id: other.id, label: other.label, subTask: nil, level: rootLevel)
        if other.subTasks != nil {
            for subTask in other.subTasks! {
                root.addSubTask(task: TaskInfo.copy(from: subTask, rootLevel: rootLevel + 1))
            }
        }
        return root
    }
    
    func addSubTask(task: TaskInfo) {
        task.parentID = id
        if subTasks != nil {
            subTasks!.append(task)
        } else {
            subTasks = [task]
        }
        task.setLevel(level: level + 1)
    }
    
    func addSubTask(_ newTask: TaskInfo, after node: TaskInfo) {
        newTask.setLevel(level: level + 1)
        if subTasks != nil {
            if let found = subTasks!.firstIndex(where: { element in element.id == node.id}) {
                subTasks!.insert(newTask, at: found + 1)
            } else {
                print("precedence node not found: \(node.id)")
            }
        } else {
            subTasks = [newTask]
        }
    }
    
    func setLevel(level: Int) {
        self.level = level
        if subTasks != nil {
            for task in subTasks! {
                task.setLevel(level: level + 1)
            }
        }
    }
    
    func preOrderTraverse() -> Array<TaskInfo> {
        var taskList = [self]
        if subTasks != nil {
            for subTask in subTasks! {
                taskList.append(contentsOf: subTask.preOrderTraverse())
            }
        }
        return taskList
    }
}
