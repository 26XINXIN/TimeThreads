//
//  TaskManagerController.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

class TaskManagerController: ObservableObject {
    @Published private(set) var target = Target.generateTestTask()
    
    
    // MARK: - Access to Data
    
    var taskList: [Task] { target.listTasks() }
    
    
    // MARK: - Intents
    
    func changeExpansion(task: Task) {
        if task.expanded {
            target.unexpand(task)
        } else {
            target.expand(task)
        }
    }
    
    func editing(task: Task) {
        removeNewlyAddedTask()
        target.editing(task)
    }
    
    func editing(subTask: SubTask) {
        removeNewlyAddedSubTask()
        target.editing(subTask)
    }
    
    func unediting(task: Task) {
        if let newlyAddedTask = target.newlyAddedTask(), newlyAddedTask.id == task.id {
            removeNewlyAddedTask()
        } else {
            target.unediting(task)
        }
        
    }
    
    func unediting(subTask: SubTask) {
        if let newlyAddedSubTask = target.newlyAddedSubTask(), newlyAddedSubTask.id == subTask.id {
            removeNewlyAddedSubTask()
        } else {
            target.unediting(subTask)
        }
    }
    
    func changeTaskLabel(_ label: String, of task: Task) {
        target.closeNewlyAddedLabel(of: task)
        unediting(task: task)
        target.setTaskLabel(label, of: task)
    }
    
    func changeSubTaskLabel(_ label: String, of subTask: SubTask) {
        target.closeNewlyAddedLabel(of: subTask)
        unediting(subTask: subTask)
        target.setSubTasklabel(label, of: subTask)
        
    }
    
    func addNewSubTask(of task: Task) {
        let subTask = SubTask(label: "New Task", parentID: task.id)
        removeNewlyAddedSubTask()
        target.addSubTask(subTask, of: task)
        target.setNewlyAdded(subTask)
        target.editing(subTask)
    }
    
    func changeFinishStatus(_ subTask: SubTask, of task: Task) {
        if subTask.finished {
            target.unfinishSubTask(subTask, of: task)
        } else {
            target.finishSubTask(subTask, of: task)
        }
    }
    
    
    private func removeNewlyAddedTask() {
        if let task = target.newlyAddedTask() {
            target.removeTask(task)
        }
    }
    
    private func removeNewlyAddedSubTask() {
        if let subTask = target.newlyAddedSubTask() {
            target.removeSubTask(subTask)
        }
    }
}
