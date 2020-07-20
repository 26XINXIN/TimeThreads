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
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(viewModel.targetList, id: \.id) { target in
                    TaskCardView(taskInfo: target.info, taskID: target.id, viewModel: self.viewModel)
                }
            }
                .navigationBarTitle("Targets")
            
        }
    }
}

struct TargetListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TaskManagerViewModel(targetList: [Target.generateTestTask()])
        return TargetListView(viewModel: viewModel)
    }
}
