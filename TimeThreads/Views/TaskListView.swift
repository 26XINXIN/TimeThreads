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
    
    init(viewModel: TaskManagerViewModel, selectedTargetID: String) {
        self.viewModel = viewModel
        self.viewModel.selectTarget(id: selectedTargetID)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(viewModel.taskList, id: \.id) { task in
                    TaskCardView(taskInfo: task.info, taskID: task.id, viewModel: self.viewModel)
                }
            }
            .navigationBarTitle(viewModel.selectedTarget!.info.label ?? "")
            
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TaskManagerViewModel(targetList: [Target.generateTestTask()])
        return TaskListView(viewModel: viewModel, selectedTargetID: viewModel.targetList[0].id)
    }
}
