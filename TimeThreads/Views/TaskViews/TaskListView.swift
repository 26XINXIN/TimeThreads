//
//  TaskListView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/20.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    var selectedTargetID: String
    
    init(viewModel: TaskManagerViewModel, selectedTargetID: String) {
        self.viewModel = viewModel
        self.selectedTargetID = selectedTargetID
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if viewModel.selectedTarget != nil {
                ForEach(self.viewModel.selectedTarget!.tasks, id: \.id) { task in
                    TaskCardView(taskInfo: task.info, taskID: task.id, viewModel: self.viewModel, cardType: .task)
                }
            }
           
        }
            .navigationBarTitle(Text(viewModel.selectedTarget?.info.label ?? ""))
            .onAppear {
                self.viewModel.selectTarget(id: self.selectedTargetID)
                self.viewModel.unselectTask()
            }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TaskManagerViewModel(targetList: [Target.generateTestTask()])
        return TaskListView(viewModel: viewModel, selectedTargetID: viewModel.targetList[0].id)
    }
}
