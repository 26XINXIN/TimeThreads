//
//  TaskModel.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/10.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct Target: Identifiable, Codable {
    var label: String
    private var tasks: [Task] = []
    
    var id: String = UUID().uuidString
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init(label: String) {
        self.label = label
    }
    
    // MARK: - accessing to data
    
    func listTasks() -> [Task] {
        tasks
    }
    
    func indexOf(task: Task) -> Int? {
        tasks.firstIndex(where: { $0.id == task.id })
    }
    
    func parentOf(subTask: SubTask) -> Int? {
        tasks.firstIndex(where: { $0.id == subTask.parentID })
    }
    
    func newlyAddedTask() -> Task? {
        for task in tasks {
            if task.newlyAdded {
                return task
            }
        }
        return nil
    }
    
    func newlyAddedSubTask() -> SubTask? {
        for task in tasks {
            for subTask in task.subTasks {
                if subTask.newlyAdded {
                    return subTask
                }
            }
        }
        return nil
    }
    
    // MARK: - mutating data
    
    mutating func addTask(_ task: Task) {
        let newTask = Task(label: task.label, targetID: task.targetID, id: task.id)
        tasks.append(newTask)
    }
    
    mutating func addTask(_ task: Task, after precedence: Task) {
        let newTask = Task(label: task.label, targetID: task.targetID, id: task.id)
        if let index = indexOf(task: precedence) {
            tasks.insert(newTask, at: index + 1)
        } else {
            print("Error: precedence not found")
        }
    }
    
    mutating func addTask(_ task: Task, before successor: Task) {
        let newTask = Task(label: task.label, targetID: task.targetID, id: task.id)
        if let index = indexOf(task: successor) {
            tasks.insert(newTask, at: index)
        } else {
            print("Error: successor not found")
        }
    }
    
    mutating func addSubTask(_ subTask: SubTask, of task: Task) {
        if let index = indexOf(task: task) {
            tasks[index].addSubTask(subTask)
        } else {
            print("Error: parent task not found")
        }
    }
    
    mutating func finishSubTask(_ subTask: SubTask, of task: Task) {
        if let index = indexOf(task: task) {
            if let subIndex = task.indexOf(subTask) {
                tasks[index].subTasks[subIndex].finished = true
            } else {
                print("Error: sub task not found")
            }
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func unfinishSubTask(_ subTask: SubTask, of task: Task) {
        if let index = indexOf(task: task) {
            if let subIndex = task.indexOf(subTask) {
                tasks[index].subTasks[subIndex].finished = false
            } else {
                print("Error: sub task not found")
            }
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func expand(_ task: Task) {
        for index in 0..<tasks.count {
            tasks[index].expanded = tasks[index].id == task.id
        }
    }
    
    mutating func unexpand(_ task: Task) {
        if let index = indexOf(task: task) {
            tasks[index].expanded = false
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func editing(_ task: Task) {
        for index in 0..<tasks.count {
            if tasks[index].id == task.id {
                tasks[index].editing = true
            } else {
                tasks[index].editing = false
            }
            for subIndex in 0..<tasks[index].subTasks.count {
                tasks[index].subTasks[subIndex].editing = false
            }
        }
    }
    
    mutating func editing(_ subTask: SubTask) {
        for index in 0..<tasks.count {
            tasks[index].editing = false
            if tasks[index].id == subTask.parentID {
                for subIndex in 0..<tasks[index].subTasks.count {
                    if tasks[index].subTasks[subIndex].id == subTask.id {
                        tasks[index].subTasks[subIndex].editing = true
                    } else {
                        tasks[index].subTasks[subIndex].editing = false
                    }
                }
            }
        }
    }
    
    mutating func unediting(_ task: Task) {
        if let index = indexOf(task: task) {
            tasks[index].editing = false
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func unediting(_ subTask: SubTask) {
        if let index = parentOf(subTask: subTask) {
            if let subIndex = tasks[index].indexOf(subTask) {
                tasks[index].subTasks[subIndex].editing = false
            } else {
                print("Error: subTask not found")
            }
        } else {
            print("Error: parent not found")
        }
    }
    
    mutating func setTaskLabel(_ label: String, of task: Task) {
        if let index = indexOf(task: task) {
            tasks[index].label = label
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func setSubTasklabel(_ label: String, of subTask: SubTask) {
        if let index = parentOf(subTask: subTask) {
            if let subIndex = tasks[index].indexOf(subTask) {
                tasks[index].subTasks[subIndex].label = label
            } else {
                print("Error: subTask not found")
            }
        } else {
            print("Error: parent not found")
        }
    }
    
    mutating func removeTask(_ task: Task) {
        if let index = indexOf(task: task) {
            tasks.remove(at: index)
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func removeSubTask(_ subTask: SubTask) {
        if let index = parentOf(subTask: subTask) {
            if let subIndex = tasks[index].indexOf(subTask) {
                tasks[index].subTasks.remove(at: subIndex)
            } else {
                print("Error: subTask not found")
            }
        } else {
            print("Error: parent not found")
        }
    }
    
    mutating func closeNewlyAddedLabel(of task: Task) {
        if let index = indexOf(task: task) {
            tasks[index].newlyAdded = false
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func closeNewlyAddedLabel(of subTask: SubTask) {
        if let index = parentOf(subTask: subTask) {
            if let subIndex = tasks[index].indexOf(subTask) {
                tasks[index].subTasks[subIndex].newlyAdded = false
            } else {
                print("Error: subTask not found")
            }
        } else {
            print("Error: task not found")
        }
    }
    
    mutating func setNewlyAdded(_ task: Task) {
        for index in 0..<tasks.count {
            if tasks[index].id == task.id {
                tasks[index].newlyAdded = true
            } else {
                tasks[index].newlyAdded = false
            }
        }
    }
    
    mutating func setNewlyAdded(_ subTask: SubTask) {
        if let index = parentOf(subTask: subTask) {
            for subIndex in 0..<tasks[index].subTasks.count {
                if tasks[index].subTasks[subIndex].id == subTask.id {
                    tasks[index].subTasks[subIndex].newlyAdded = true
                } else {
                    tasks[index].subTasks[subIndex].newlyAdded = false
                }
            }
        } else {
            print("Error: task not found")
        }
    }
    
    // MARK: - Generate test data
    
    
    static func generateTestTask() -> Target {
        var target = Target(label: "target")
        let task1 = Task(label: "first task", targetID: target.id)
        let subTask1 = SubTask(label: "sub task of the first task", parentID: task1.id)
        let task2 = Task(label: "second task", targetID: target.id)
        target.addTask(task1)
        target.addSubTask(subTask1, of: task1)
        target.addTask(task2)
        target.closeNewlyAddedLabel(of: task1)
        target.closeNewlyAddedLabel(of: task2)
        target.closeNewlyAddedLabel(of: subTask1)
        return target
    }
    
}

struct Task: Identifiable, Codable {
    var label: String
    var targetID: String
    var subTasks: [SubTask] = []
    var id: String = UUID().uuidString
    
    var expanded: Bool = false
    var editing: Bool = false
    var newlyAdded: Bool = false
    var finished: Bool { subTasks.allSatisfy { $0.finished } }
    
    // MARK: - accessing to data
    
    func indexOf(_ subTask: SubTask) -> Int? {
        subTasks.firstIndex { $0.id == subTask.id }
    }
    
    // MARK: - settting data
    
    mutating func addSubTask(_ subTask: SubTask) {
        let newSubTask = SubTask(label: subTask.label, parentID: id, editing: subTask.editing, id: subTask.id)
        subTasks.append(newSubTask)
    }
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
}

struct SubTask: Identifiable, Codable {
    var label: String
    var parentID: String
    var editing: Bool = false
    var finished: Bool = false
    var newlyAdded: Bool = false
    var id: String = UUID().uuidString
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
}
