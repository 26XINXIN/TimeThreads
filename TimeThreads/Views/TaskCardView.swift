//
//  TaskCardView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/7.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TaskCardView: View {
    var taskInfo: TaskInfo
    var taskID: String
    var viewModel: TaskManagerViewModel
    var label: String {
        taskInfo.label ?? "Unknown"
    }
    var estimatedTime: Time {
        taskInfo.estimatedTime ?? Time(0)
    }
    
    @State var expanded = false
    @State var editing = false
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: self.cardCornerRaduis)
                .foregroundColor(self.cardColor)
                .opacity(self.cardOpacity)
            VStack(spacing: subTaskSpacing) {
                HeadView()
                if expanded {
                    //SubTaskListView()
                }
            }
        }
            .frame(width: cardWidth, height: cardHeight)
    }
    
    @ViewBuilder
    private func HeadView() -> some View {
        HStack(alignment: .center, spacing: spacing) {
            if taskInfo.done {
                Image(systemName: "checkmark")
                    .frame(width: shortcutButtonSize, height: shortcutButtonSize)
                    .aspectRatio(1, contentMode: .fit)
            } else {
                Text("\(Int(taskInfo.progress))%")
                    .frame(width: shortcutButtonSize, height: shortcutButtonSize)
                    .aspectRatio(1, contentMode: .fit)
            }
                
            NavigationLink(destination: TaskListView(viewModel: viewModel, selectedTargetID: taskID)) {
                Text(label)
                    .font(.system(size: lineHeight))
                    .frame(width: cardWidth - shortcutButtonSize - 2 * edgePaddingSize - spacing, height: lineHeight, alignment: .leading)
                    .onLongPressGesture {
                        self.editing = true
                    }
//                    .sheet(item: $editing, content: EditingView(taskInfo: taskInfo, viewModel: viewModel)) // TODO
            }
            
//            Image(systemName: "chevron.down.circle")
//                .opacity(0.6)
//                .frame(width: shortcutButtonSize, height: shortcutButtonSize)
//                .aspectRatio(1, contentMode: .fit)
//                .rotationEffect(expanded ? Angle.degrees(0) : Angle.degrees(-90))
//                .onTapGesture {
//                    self.expanded = true
//                }
        }
            .frame(width: cardWidth - 2 * edgePaddingSize, height: lineHeight)
    }
    
    
    
    // MARK: Constants
    
    private let lineHeight: CGFloat = 32
    private let subTaskLineHeight: CGFloat = 20
    private let maxWidth: CGFloat = UIScreen.main.bounds.width
    private var subTaskListHeight: CGFloat {
        3 * subTaskLineHeight + 3 * subTaskSpacing
    }
    private var cardWidth: CGFloat {
        return maxWidth - 2 * horizontalPaddingSize
    }
    private var cardHeight: CGFloat {
        if expanded {
            return lineHeight + 2 * verticalPaddingSize + subTaskListHeight + subTaskSpacing
        } else {
            return lineHeight + 2 * verticalPaddingSize
        }
    }
    
    private let shortcutButtonSize: CGFloat = 32
    
    private let buttonHeight: CGFloat = 40
    private let buttonWidth: CGFloat = 90
    private let buttonFontSize: CGFloat = 15
    
    private let horizontalPaddingSize: CGFloat = 5
    private let verticalPaddingSize: CGFloat = 16
    private let edgePaddingSize: CGFloat = 8
    
    private let labelFontSize: CGFloat = 30
    
    private let cardColor = Color.blue
    private let cardOpacity: Double = 0.5
    private let cardCornerRaduis: CGFloat = 10.0
    
    private let indentSizePerLevel: CGFloat = 20
//    private var indentSize: CGFloat {
//        indentSizePerLevel * CGFloat(max(task.level-1, 0))
//    }
    
    private let spacing: CGFloat = 4
    private let subTaskSpacing: CGFloat = 7
    
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        let targetList = [Target.generateTestTask()]
        let viewModel = TaskManagerViewModel(targetList: targetList)
        return TaskCardView(taskInfo: targetList[0].info, taskID: targetList[0].id, viewModel: viewModel)
    }
}
