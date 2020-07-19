//
//  TaskModel.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/10.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct Target: Identifiable, Codable {
    private(set) var info: TaskInfo
    private(set) var tasks: [Task] = []
    var id: String = UUID().uuidString
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init(info: TaskInfo) {
        self.info = info
    }
    
    // MARK: - accessing to data
    
    func indexOf(_ taskID: String) -> Int? {
        tasks.indexByID(taskID)
    }
    
    func getTask(withID id: String) -> Task? {
        if let index = indexOf(id) {
            return tasks[index]
        } else {
            return nil
        }
    }
    
    // MARK: - mutating data
    
    mutating func addTask(info: TaskInfo) {
        let task = Task(info: info, parentID: id)
        tasks.append(task)
    }
    
    
    mutating func addSubTask(info: TaskInfo, of taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: parent task not found")
            return
        }
        tasks[index].addSubTask(info: info)
    }
    
    mutating func updateTask(info: TaskInfo, of task: String) {
        guard let index = indexOf(task) else {
            print("Error: task not found")
            return
        }
        tasks[index].update(info: info)
    }
    
    mutating func updateSubTask(info: TaskInfo, withID subTaskID: String, of taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: parent not found")
            return
        }
        tasks[index].updateSubTask(info: info, of: subTaskID)
    }
    
    mutating func removeTask(id taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: task not found")
            return
        }
        tasks.remove(at: index)
    }
    
    mutating func removeSubTask(id subTaskID: String, of taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: parent not found")
            return
        }
        tasks[index].removeSubTask(subTaskID)
    }
    
    mutating func moveTask(id: String, before successorID: String) {
        guard let i = indexOf(id) else {
            print("Error: task not found")
            return
        }
        guard let j = indexOf(successorID) else {
            print("Error: successor not found")
            return
        }
        let task = tasks[i]
        tasks.remove(at: i)
        tasks.insert(task, at: j)
    }
    
    mutating func moveSubTask(id: String, before successorID: String, of taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: task not found")
            return
        }
        tasks[index].move(subTask: id, before: successorID)
    }
    
    // MARK: - Generate test data
    
    
    static func generateTestTask() -> Target {
        var target = Target(info: TaskInfo(label: "Target", estimatedTime: nil))
        let taskInfo1 = TaskInfo(label: "Task 1", estimatedTime: nil)
        target.addTask(info: taskInfo1)
        let taskInfo2 = TaskInfo(label: "Task 2", estimatedTime: nil)
        target.addTask(info: taskInfo2)
        target.addSubTask(info: TaskInfo(label: "SubTask 1", estimatedTime: nil), of: target.tasks[0].id)
        return target
    }
    
}

