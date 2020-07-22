//
//  TaskEditingView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/20.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TaskEditingView: View {
    @State var label: String = ""
//    @State var estimatedTime: Time = Time(0)
    @State var done: Bool = false
    
    var taskInfo: TaskInfo
    var taskID: String?
    @ObservedObject var viewModel: TaskManagerViewModel
    var cardType: CardType
    @Binding var isPresented: Bool
    
    init(taskInfo: TaskInfo, taskID: String?, viewModel: TaskManagerViewModel, cardType: CardType, isPresented: Binding<Bool>) {
        self.taskInfo = taskInfo
        self.taskID = taskID
        self.viewModel = viewModel
        self.cardType = cardType
        self._isPresented = isPresented
        self.label = taskInfo.label ?? "Unknown"
//        self.estimatedTime = taskInfo.estimatedTime ?? Time(0)
        self.done = taskInfo.done
        
    }
    
    var body: some View {
        VStack(alignment: .center) {
            TextField(taskInfo.label ?? "Unknown", text: $label)
                .foregroundColor(Color.black)
                .font(.system(size: 50))
                .padding(.vertical, 10)
//            ScrollView(.vertical) {
//                TextField("Time", text: $estimatedTime)
//                    .foregroundColor(Color.black)
//                    .font(.system(size: lineHeight))
//            }
            HStack() {
                Button(action: { self.acceptChanges() }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Accept")
                    }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(40)
                        .font(.system(size:26))
                }
                Button(action: { self.discardChanges() }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Cancel")
                    }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(40)
                        .font(.system(size:26))
                }
            }
            Spacer(minLength: 20)
        }
            .padding(.horizontal, edgePaddingSize)
        
    }
    
    private func acceptChanges() {
        let info = TaskInfo(label: label)
        if let id = taskID { // updating
            switch cardType {
            case .target:
                viewModel.updateTarget(info: info, of: id)
            case .task:
                viewModel.updateTask(info: info, of: id)
            case .subTask:
                viewModel.updateSubTask(info: info, of: id)
            }
        } else {
            switch cardType {
            case .target:
                viewModel.addTarget(info: info)
            case .task:
                viewModel.addTask(info: info)
            case .subTask:
                viewModel.addSubTask(info: info)
            }
        }
        self.isPresented = false
    }
    
    private func discardChanges() {
        self.isPresented = false
    }
    
    private let lineHeight: CGFloat = 32
    
    private let edgePaddingSize: CGFloat = 14
    private let buttonSize: CGFloat = 40
}

struct TaskEditingView_Previews: PreviewProvider {
    static var previews: some View {
        let target = Target.generateTestTask()
        let viewModel = TaskManagerViewModel(targetList: [target])
        let taskInfo = TaskInfo(label: "Test", estimatedTime: Time(80), done: false, progress: 0)
        return TaskEditingView(taskInfo: taskInfo, taskID: "1", viewModel: viewModel, cardType: .target, isPresented: Binding.constant(false))
    }
}
