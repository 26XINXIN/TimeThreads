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
    
    private var target: Target { manager.target }
    private var taskList: [Task] { manager.taskList }
    
    var body: some View {
        VStack {
            TargetView(target: target)
            ScrollView(.vertical) {
                ForEach(taskList[0..<taskList.count], id: \.id) { task in
                    TaskCardView(task: task, manager: self.manager)
//                        .onTapGesture(count: 2) { // TODO: - not finalized gesture
//                            // TODO: - user create new task
//                            self.manager.addSiblingTask(TaskInfo(id: UUID().uuidString, label: "new task (TODO)", level: task.level, expanded: true, shortcutButtonExpanded: false), after: task)
//                        }
//                        .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
//                            var changed = false
//                            let _ = providers.first!.loadObject(ofClass: String.self) { id, err in
//                                if id != nil {
//                                    if let insertedTask = self.manager.getTaskById(id!) {
//                                        self.manager.move(insertedTask, before: task)
//                                        changed = true
//                                    }
//                                }
//                            }
//                            return changed
//                        }
//                        .onDrag {NSItemProvider(object: task.id as NSString)}
                }
                Text("- Task finished -")
                    .font(Font.system(size: 15))
                    .foregroundColor(Color.gray)
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
        return TasksManagerView(manager: controller)
    }
}
