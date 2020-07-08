//
//  TasksManagerView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TasksManagerView: View {
    @ObservedObject var manager: TaskManagerController
    
    @State var rootTask: TaskInfo
    private var taskList: [TaskInfo] { manager.listTasks(rooted: rootTask) }
    private var rootLevel: Int { rootTask.level }
    
    var body: some View {
        VStack {
            TaskHeadingView(task: taskList.first!)
                .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                    var changed = false
                    let _ = providers.first!.loadObject(ofClass: String.self) { id, err in
                        if id != nil {
                            if let newRootTask = self.manager.getTaskById(id!) {
                                self.rootTask = newRootTask
                                changed = true
                            }
                        }
                    }
                    return changed
                }
                .onTapGesture(count: 2) {
                    self.rootTask = self.manager.rootTask
                }
            ScrollView(.vertical) {
                ForEach(taskList[1..<taskList.count], id: \.id) { task in
                    TaskCardView(task: TaskInfo(id: task.id, label: task.label, level: task.level - self.rootLevel), manager: self.manager)
                    .onTapGesture(count: 2) { // TODO: - not finalized gesture
                        // TODO: - user create new task
                        self.manager.addSiblingTask(TaskInfo(id: UUID().uuidString, label: "new task (TODO)", level: task.level), after: task)
                    }
                    .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                        var changed = false
                        let _ = providers.first!.loadObject(ofClass: String.self) { id, err in
                            if id != nil {
                                if let insertedTask = self.manager.getTaskById(id!) {
                                    self.manager.move(insertedTask, before: task)
                                    changed = true
                                }
                            }
                        }
                        return changed
                    }
                    .onDrag {NSItemProvider(object: task.id as NSString)}
                }
                
            }
                .edgesIgnoringSafeArea(.bottom)
                .animation(.linear)
        }
    }
    
    // MARK: - Constant(s)
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let lineHeight: CGFloat = 40.0
}




struct TasksManagerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = TaskManagerController()
        return TasksManagerView(manager: controller, rootTask: controller.rootTask)
    }
}
