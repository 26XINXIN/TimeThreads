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
    
    init(viewModel: TaskManagerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(viewModel.targetList, id: \.id) { target in
                    TaskCardView(taskInfo: target.info, taskID: target.id, viewModel: self.viewModel, cardType: .target)
                }
            }
            .navigationBarTitle(Text("Targets"))
            .onAppear {
                self.viewModel.unselectTarget()
            }
        }
    }
}

struct TargetListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TaskManagerViewModel(targetList: [Target.generateTestTask()])
        return TargetListView(viewModel: viewModel)
    }
}
