//
//  TaskManagerViewModel.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

class TaskManagerViewModel: ObservableObject {
    @Published var targetList: [Target] {
        didSet {
            reload()
        }
    }
    
    @Published var selectedTarget: Target? = nil {
        didSet {
            loadTarget()
        }
    }
    @Published var selectedTask: Task? = nil {
        didSet {
            loadTask()
        }
    }
    @Published var selectedSubTask: SubTask? = nil
    
    @Published var taskList: [Task] = []
    @Published var subTaskList: [SubTask] = []
    
    var targetIndex: Int? {
        if let targetID = selectedTarget?.id {
            return targetList.indexByID(targetID)
        } else {
            return nil
        }
    }
    
    var taskIndex: Int? {
        if let taskID = selectedTask?.id {
            return selectedTarget?.indexOf(taskID)
        } else {
            return nil
        }
    }
    
    var subTaskIndex: Int? {
        if let subTaskID = selectedSubTask?.id {
            return selectedTask?.indexOf(subTaskID)
        } else {
            return nil
        }
    }
    
    init(targetList: [Target]) {
        self.targetList = targetList
    }
    
    private func reload() {
        if selectedTarget == nil {
            return
        }
        if targetIndex == nil {
            print("(reload) Error: target not found")
            return
        }
        selectedTarget = targetList[targetIndex!]
    }
    
    private func loadTarget() {
        taskList = selectedTarget?.tasks ?? []
        
        if selectedTask == nil {
            return
        }
        if taskIndex == nil {
            print("(loadTarget) Error: task not found")
            return
        }
        selectedTask = taskList[taskIndex!]
    }
    
    private func loadTask() {
        subTaskList = selectedTask?.subTasks ?? []
        if selectedSubTask == nil {
            return
        }
        if subTaskIndex == nil {
            print("(loadTask) Error: subTask not found")
            return
        }
        selectedSubTask = subTaskList[subTaskIndex!]
    }
    
    
    // MARK: - Access to Data
    
    private func isValidTarget() -> Bool {
        if selectedTarget == nil {
            print("Error: target not selected")
            return false
        }
        if targetIndex == nil {
            print("Error: target not found")
            return false
        }
        return true
    }
    
    private func isValidTask() -> Bool {
        if selectedTask == nil {
            print("Error: task not selected")
            return false
        }
        if taskIndex == nil {
            print("Error: task not found")
            return false
        }
        return true
    }
    
    // MARK: - Intents
    
    func addTask(info: TaskInfo) {
        if !isValidTarget() {
            return
        }
        targetList[targetIndex!].addTask(info: info)
    }
    
    func addSubTask(info: TaskInfo) {
        if !isValidTarget() && !isValidTask() {
            return
        }
        targetList[targetIndex!].addSubTask(info: info, of: selectedTask!.id)
    }
    
    func removeTask(id: String) {
        if !isValidTarget() {
            return
        }
        targetList[targetIndex!].removeTask(id: id)
    }
    
    func removeSubTask(id: String) {
        if !isValidTarget() && !isValidTask() {
            return
        }
        targetList[targetIndex!].removeSubTask(id: id, of: selectedTask!.id)
    }
    
    func moveTask(id: String, before successor: String) {
        if !isValidTarget() {
            return
        }
        targetList[targetIndex!].moveTask(id: id, before: successor)
    }
    
    func moveSubTask(id: String, before successor: String) {
        if !isValidTarget() && !isValidTask() {
            return
        }
        targetList[targetIndex!].moveSubTask(id: id, before: successor, of: selectedTask!.id)
    }
    
    func updateTask(info: TaskInfo, of id: String) {
        if !isValidTarget() {
            return
        }
        targetList[targetIndex!].updateTask(info: info, of: id)
    }
    
    func updateSubTask(info: TaskInfo, of id: String) {
        if !isValidTarget() && !isValidTask() {
            return
        }
        targetList[targetIndex!].updateSubTask(info: info, withID: id, of: selectedTask!.id)
    }
    
    func selectTarget(id: String) {
        guard let index = targetList.indexByID(id) else {
            print("(selectTarget) Error: target not found")
            return
        }
        selectedTarget = targetList[index]
        print("target \(selectedTarget!.info.label!) selected")
    }
    
    func selectTask(id: String) {
        if !isValidTarget() {
            return
        }
        guard let index = taskList.indexByID(id) else {
            print("Error: Task not found")
            return
        }
        selectedTask = taskList[index]
        print("task \(selectedTask!.info.label!) selected")
    }
    
    func selectSubTask(id: String) {
        if !isValidTarget() && !isValidTask() {
            return
        }
        guard let index = subTaskList.indexByID(id) else {
            print("(selectSubTask) Error: subTask not found")
            return
        }
        selectedSubTask = subTaskList[index]
    }
    
    func unselectTarget() {
        selectedTarget = nil
        print("target unselected")
    }
    
    func unselectTask() {
        selectedTask = nil
        print("task unselected")
    }
    
    func unselectSubTask() {
        selectedSubTask = nil
    }
}

