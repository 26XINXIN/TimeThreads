//
//  TargetListView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/19.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TargetListView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    
    @State var addingNewTask = false
    
    init(viewModel: TaskManagerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                    ForEach(viewModel.targetList, id: \.id) { target in
                        TaskCardView(taskInfo: target.info, taskID: target.id, viewModel: self.viewModel, cardType: .target)
                        // Text(target.info.label ?? "Unknown")
                    }
            }
            .navigationBarTitle(Text("Targets"))
            .navigationBarItems(trailing:
                Button(action: { self.addingNewTask = true }) {
                    Image(systemName: "plus")
                }
            )
                .sheet(isPresented: $addingNewTask) {
                    TaskEditingView(taskInfo: TaskInfo(), taskID: nil, viewModel: self.viewModel, cardType: .target, isPresented: self.$addingNewTask)
                }
        }
        .onAppear {
            self.viewModel.unselectTarget()
        }
        .animation(.spring())
    }
}

struct TargetListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TaskManagerViewModel(targetList: [Target.generateTestTask()])
        return TargetListView(viewModel: viewModel)
    }
}
