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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                ForEach(self.manager.listTasks(), id: \.id) { task in
                        TaskView(task: task)
                            .frame(minWidth: nil, idealWidth: self.screenWidth - 10, maxWidth: self.screenWidth - 10, minHeight: self.lineHeight, idealHeight: self.lineHeight, maxHeight: 2 * self.lineHeight, alignment: .topLeading)
                        .onTapGesture(count: 2) {
                            // TODO: user create new task
                            self.manager.addSiblingTask(TaskInfo(id: UUID().uuidString, label: "new task (TODO)", subTask: nil, level: 0), after: task)
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Constant(s)
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let lineHeight: CGFloat = 40.0
}


struct TaskView: View {
    var task: TaskInfo
    
    var body: some View {
        GeometryReader { geometry in
            if self.task.level == 0 {
                Text(self.task.label)
                    .font(Font.system(size: self.fontSize(for: geometry.size)))
                    .headify()
            } else {
                Text(self.task.label).cardify()
                .frame(minWidth: nil, idealWidth: geometry.size.width - 10, maxWidth: geometry.size.width - 10, minHeight: geometry.size.height, idealHeight: geometry.size.height, maxHeight: 2 * geometry.size.height, alignment: .topLeading)
                .padding(5)
                .padding(.leading, 20 * CGFloat(self.task.level-1))
            }
        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat { min(size.width, size.height) * 0.9 }
}





struct TasksManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TasksManagerView(manager: TaskManagerController())
    }
}
