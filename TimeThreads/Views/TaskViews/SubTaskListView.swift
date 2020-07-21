//
//  SubTaskListView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/20.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct SubTaskListView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    var selectedTaskID: String
    
    init(viewModel: TaskManagerViewModel, selectedTaskID: String) {
        self.viewModel = viewModel
        self.selectedTaskID = selectedTaskID
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if viewModel.selectedTask != nil {
                ForEach(viewModel.selectedTask!.subTasks, id: \.id) { subTask in
                    TaskCardView(taskInfo: subTask.info, taskID: subTask.id, viewModel: self.viewModel, cardType: .subTask)
                }
            }
            
        }
            .navigationBarTitle(Text(viewModel.selectedTask?.info.label ?? ""))
            .onAppear {
                self.viewModel.selectTask(id: self.selectedTaskID)
            }
    }
    
    
}

struct SubTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let target = Target.generateTestTask()
        let viewModel = TaskManagerViewModel(targetList: [target])
        viewModel.selectTarget(id: target.id)
        return SubTaskListView(viewModel: viewModel, selectedTaskID: target.tasks[0].id)
    }
}
