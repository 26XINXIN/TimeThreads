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
    
    @State private var expanded: Bool = false
    @State private var shortcutBottonExpanded: Bool = true
    
    @State private var taskLabel: String = ""
    
    init(task content: TaskInfo, manager: TaskManagerController) {
        self.task = content
        self.manager = manager
        self.taskLabel = content.label
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: self.cardCornerRaduis)
                .foregroundColor(self.cardColor)
                .opacity(self.cardOpacity)
            VStack {
                if self.expanded {
                    TextField("\(self.task.label)", text: self.$taskLabel)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.leading, 5)
                        .frame(width: cardWidth, height: lineHeight, alignment: .leading)
                        .position(x: cardWidth / 2, y: self.lineHeight / 2)
                    HStack{
                        ButtonView(label: "Apply", width: buttonWidth, height: buttonHeight, fontSize: buttonFontSize, color: Color.green) {
                            // TODO: editing button
                            self.expanded = false
                        }
                        ButtonView(label: "Discard", width: buttonWidth, height: buttonHeight, fontSize: buttonFontSize, color: Color.red) {
                            // TODO: editing button
                            self.expanded = false
                        }
                    }
                } else {
                    HStack {
                        Text(self.task.label)
                        .padding(.leading, edgePaddingSize)
                        .frame(width: cardWidth - shortcutButtonWidth - edgePaddingSize, height: lineHeight, alignment: .leading)
                        .position(x: (cardWidth - shortcutButtonWidth - edgePaddingSize) / 2, y: self.lineHeight / 2)
                        .onLongPressGesture {
                            self.expanded = true
                        }
                        if shortcutBottonExpanded {
                            Image(systemName: "plus").font(.system(size: shortcutButtonSize, weight: .regular))
                                .onTapGesture {
                                    // TODO: editing new task
                                    self.manager.addSubTask(TaskInfo(id: UUID().uuidString, label: "new child"), of: self.task)
                                }
                            Image(systemName: "minus").font(.system(size: shortcutButtonSize, weight: .regular))
                                .onTapGesture {
                                    self.manager.deleteTask(self.task)
                                }
                        }
                        Image(systemName: "square.grid.2x2").font(.system(size: shortcutButtonSize, weight: .regular))
                            .padding(.trailing, edgePaddingSize)
                            .onTapGesture {
                                self.shortcutBottonExpanded = !self.shortcutBottonExpanded
                            }
                    }
                    
                }
            }
                .padding(.vertical, verticalPaddingSize)
            
        }
            .font(Font.system(size: fontSize))
            .frame(width: cardWidth, height: cardHeight)
            .padding(.horizontal, horizontalPaddingSize)
            
            .padding(.leading, indentSize)
            
        
            
    }
    
    
    // MARK: Constants
    
    private let lineHeight: CGFloat = 40
    private let maxWidth: CGFloat = UIScreen.main.bounds.width
    private var cardWidth: CGFloat {
        return maxWidth - indentSize - 2 * horizontalPaddingSize
    }
    private var cardHeight: CGFloat {
        if expanded {
            return lineHeight + buttonHeight + 2 * verticalPaddingSize
        } else {
            return lineHeight + 2 * verticalPaddingSize
        }
    }
    
    private let shortcutButtonSize: CGFloat = 20
    private var shortcutButtonWidth: CGFloat { 3 * shortcutButtonSize }
    
    private let buttonHeight: CGFloat = 40
    private let buttonWidth: CGFloat = 90
    private let buttonFontSize: CGFloat = 15
    
    private let horizontalPaddingSize: CGFloat = 5
    private let verticalPaddingSize: CGFloat = 5
    private let edgePaddingSize: CGFloat = 5
    
    private let fontSize: CGFloat = 20
    
    private let cardColor = Color.blue
    private let cardOpacity: Double = 0.5
    private let cardCornerRaduis: CGFloat = 10.0
    
    private let indentSizePerLevel: CGFloat = 20
    private var indentSize: CGFloat {
        indentSizePerLevel * CGFloat(max(task.level-1, 0))
    }
    
    
    
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = TaskManagerController()
        return TaskCardView(task: TaskInfo(id: "1", label: "test", level: 2), manager: manager)
    }
}
