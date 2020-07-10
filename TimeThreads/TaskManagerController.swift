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
    
    var rootTask: TaskInfo { task.rootTask }
    var taskList: [TaskInfo] { listTasks(rooted: rootTask) }
    
    func listTasks(rooted root: TaskInfo) -> Array<TaskInfo> {
        task.preOrderTraverse(rooted: root)
    }
    
    func getTaskById(_ id: String) -> TaskInfo? {
        task.findTaskNode(id: id)
    }
    
    // MARK: - Intents
    
    func addSiblingTask(_ newTask: TaskInfo, after node: TaskInfo) {
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
    
    func move(_ insertedTask: TaskInfo, before successor: TaskInfo) {
        if insertedTask.id == successor.id {
            print("no movement")
            return
        }
        if insertedTask.parentID == nil {
            print("Error: Can not move root node")
            return
        }
        if successor.parentID == nil {
            print("Error: Can not inserted to root node")
            return
        }
        if successor.parentID == insertedTask.id {
            print("Error: moving task to its subTask list is not allowed")
            return
        }
        
        let srcParent = task.findTaskNode(id: insertedTask.parentID!)
        let dstParent = task.findTaskNode(id: successor.parentID!)
        
        if srcParent == nil || dstParent == nil {
            print("Error: Parent not found")
            return
        }
        
        // delete from previous tree
        srcParent!.removeSubTask(insertedTask)
        // insert to new
        dstParent!.addSubTask(insertedTask, before: successor)
        
        // TODO: bad change signal
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func move(_ insertedTask: TaskInfo, after precedence: TaskInfo) {
        if insertedTask.id == precedence.id {
            print("no movement")
            return
        }
        if insertedTask.parentID == nil {
            print("Error: Can not move root node")
            return
        }
        if precedence.parentID == nil {
            print("Error: Can not inserted to root node")
            return
        }
        if precedence.parentID == insertedTask.id {
            print("Error: moving task to its subTask list is not allowed")
            return
        }
        
        let srcParent = task.findTaskNode(id: insertedTask.parentID!)
        let dstParent = task.findTaskNode(id: precedence.parentID!)
        
        if srcParent == nil || dstParent == nil {
            print("Error: Parent not found")
            return
        }
        
        // delete from previous tree
        srcParent!.removeSubTask(insertedTask)
        // insert to new
        dstParent!.addSubTask(insertedTask, after: precedence)
        
        // TODO: bad change signal
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func addSubTask(_ newTask: TaskInfo, of parent: TaskInfo) {
        print("adding subtask")
        if let trueParent = task.findTaskNode(id: parent.id) {
            trueParent.addSubTask(task: newTask)
            // TODO: bad change signal
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } else {
            print("ID error")
        }
    }
    
    func deleteTask(_ deletedTask: TaskInfo) {
        if let trueTask = task.findTaskNode(id: deletedTask.id) {
            if trueTask.parentID == nil {
                print("Error: can not delete root task")
                return
            }
            
            if let parent = task.findTaskNode(id: trueTask.parentID!) {
                parent.removeSubTask(trueTask)
            } else {
                print("Error: parent not found")
                return
            }
            // TODO: bad change signal
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } else {
            print("ID error")
        }
    }
    
    func updateTask(_ updatedTask: TaskInfo, label: String? = nil) {
        if let trueTask = task.findTaskNode(id: updatedTask.id) {
            trueTask.update(label: label)
            // TODO: bad change signal
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } else {
            print("Error: task not found")
        }
    }
    
    func changeExpansion(task expandedTask: TaskInfo) {
        task.changeExpansion(task: expandedTask)
        // TODO: bad change signal
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func changeButtonsExpansion(task expandedTask: TaskInfo) {
        task.changeButtonsExpansion(task: expandedTask)
        // TODO: bad change signal
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func editing(task editedTask: TaskInfo) {
        for tmpTask in task.preOrderTraverse(rooted: rootTask) {
            if tmpTask.id == editedTask.id {
                tmpTask.editing = true
            } else {
                tmpTask.editing = false
            }
        }
        // TODO: bad change signal
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func unEditing(task editedTask: TaskInfo) {
        if let trueTask = task.findTaskNode(id: editedTask.id) {
            trueTask.editing = false
            // TODO: bad change signal
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } else {
            print("Error: task not found")
        }
    }
}
