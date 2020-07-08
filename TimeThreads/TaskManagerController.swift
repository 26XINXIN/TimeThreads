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
}
