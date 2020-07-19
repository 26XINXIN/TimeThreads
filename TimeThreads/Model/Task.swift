//
//  Task.swift
//  
//
//  Created by 杨鑫 on 2020/7/19.
//

import Foundation

struct Task: Identifiable, Codable {
    private(set) var info: TaskInfo
    private(set) var subTasks: [SubTask] = []
    private(set) var parentID: String
    var id: String = UUID().uuidString
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init(info: TaskInfo, parentID: String) {
        self.info = info
        self.parentID = parentID
    }
    
    // MARK: - accessing to data
    
    func indexOf(_ id: String) -> Int? {
        subTasks.indexByID(id)
    }
    
    func getSubTask(withID id: String) -> SubTask? {
        if let index = indexOf(id) {
            return subTasks[index]
        } else {
            return nil
        }
    }
    
    // MARK: - settting data
    
    mutating func update(info: TaskInfo) {
        self.info = info
    }
    
    mutating func addSubTask(info: TaskInfo) {
        let subTask = SubTask(info: info, parentID: id)
        subTasks.append(subTask)
    }
    
    mutating func updateSubTask(info: TaskInfo, of taskID: String) {
        guard let index = indexOf(taskID) else {
            print("Error: subTask not found")
            return
        }
        subTasks[index].update(info: info)
    }
    
    mutating func removeSubTask(_ subTaskId: String) {
        guard let index = indexOf(subTaskId) else {
            print("Error: subTask not found")
            return
        }
        subTasks.remove(at: index)
    }
    
    mutating func move(subTask: String, before successorID: String) {
        guard let i = indexOf(subTask) else {
            print("Error: subTask not found")
            return
        }
        guard let j = indexOf(successorID) else {
            print("Error: successor not found")
            return
        }
        let movedTask = subTasks[i]
        subTasks.remove(at: i)
        subTasks.insert(movedTask, at: j)
    }
}



