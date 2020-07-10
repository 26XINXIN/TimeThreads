//
//  TaskCardView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/7.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TaskCardView: View {
    var task: TaskInfo
    private var manager: TaskManagerController
    
    private var expanded: Bool
    private var shortcutButtonExpanded: Bool
    private var editing: Bool
    
    @State private var taskLabel: String = ""
    
    init(task content: TaskInfo, manager: TaskManagerController) {
        self.task = content
        self.expanded = task.expanded
        self.shortcutButtonExpanded = task.shortcutButtonExpanded
        self.manager = manager
        self.editing = task.editing
        self.taskLabel = content.label
        
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: self.cardCornerRaduis)
                .foregroundColor(self.cardColor)
                .opacity(self.cardOpacity)
            VStack(spacing: subTaskSpacing) {
                HeadView()
                if expanded {
                    SubTaskView()
                }
            }
//                .padding(.horizontal, edgePaddingSize)
//                .padding(.vertical, verticalPaddingSize)
            
        }
            .frame(width: cardWidth, height: cardHeight)
    }
    
    @ViewBuilder
    private func HeadView() -> some View {
        HStack(alignment: .center, spacing: spacing) {
            if editing {
                TextField("\(self.task.label)", text: self.$taskLabel)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: lineHeight))
                    .frame(width: nil, height: lineHeight, alignment: .leading)
                Image(systemName: "checkmark")
                    .foregroundColor(Color.green)
                    .frame(width: shortcutButtonSize, height: shortcutButtonSize)
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        // TODO: editing new task
                        self.manager.addSubTask(TaskInfo(id: UUID().uuidString, label: "new child"), of: self.task)
                    }
                Image(systemName: "xmark")
                    .foregroundColor(Color.red)
                    .frame(width: shortcutButtonSize, height: shortcutButtonSize)
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        self.manager.deleteTask(self.task)
                    }
            } else {
                Text(self.task.label)
                    .font(.system(size: lineHeight))
                    .frame(width: cardWidth - shortcutButtonSize - 2 * edgePaddingSize - spacing, height: lineHeight, alignment: .leading)
                    .onLongPressGesture { self.manager.editing(task: self.task)}
            }
            Image(systemName: "chevron.down.circle")
                .opacity(0.6)
                .frame(width: shortcutButtonSize, height: shortcutButtonSize)
                .aspectRatio(1, contentMode: .fit)
                .rotationEffect(expanded ? Angle.degrees(0) : Angle.degrees(-90))
                .onTapGesture {
                    self.manager.changeExpansion(task: self.task)
                }
        }
            .frame(width: cardWidth - 2 * edgePaddingSize, height: lineHeight)
    }
    
    @ViewBuilder
    private func SubTaskView() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: subTaskSpacing) {
                ForEach(task.subTasks, id: \.id) { subTask in
                    HStack(spacing: self.spacing) {
                        Image(systemName: "checkmark.circle")
                            .frame(width: self.subTaskLineHeight, height: self.subTaskLineHeight)
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture {
                                // TODO: add subtask
                                self.manager.addSubTask(TaskInfo(id: UUID().uuidString, label: "newly added subtask"), of: self.task)
                            }
                        Text(subTask.label)
                            .frame(width: self.cardWidth - self.subTaskLineHeight - 2 * self.edgePaddingSize - self.spacing, height: self.subTaskLineHeight, alignment: .leading)
                    }
                }
                HStack(spacing: self.spacing) {
                    Image(systemName: "plus.app")
                        .frame(width: subTaskLineHeight, height: subTaskLineHeight)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            // TODO: add subtask
                            self.manager.addSubTask(TaskInfo(id: UUID().uuidString, label: "newly added subtask"), of: self.task)
                        }
                    Text("Add new subTask")
                        .frame(width: cardWidth - subTaskLineHeight - 2 * edgePaddingSize - spacing, height: subTaskLineHeight, alignment: .leading)
                        .opacity(0.3)
                }
            }
            
        }
        .frame(width: cardWidth - 2 * edgePaddingSize, height: subTaskListHeight)
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
            return lineHeight + 2 * verticalPaddingSize + subTaskListHeight
        } else {
            return lineHeight + 2 * verticalPaddingSize
        }
    }
    
    private let shortcutButtonSize: CGFloat = 28
    
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
    private var indentSize: CGFloat {
        indentSizePerLevel * CGFloat(max(task.level-1, 0))
    }
    
    private let spacing: CGFloat = 4
    private let subTaskSpacing: CGFloat = 7
    
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = TaskManagerController()
        let task = TaskInfo(id: "1", label: "test", level: 1, expanded: true, editing: false)
        task.addSubTask(task: TaskInfo(id: "2", label: "testtest"))
        return TaskCardView(task: task, manager: manager)
    }
}
