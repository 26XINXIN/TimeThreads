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
    
    @State private var expanded: Bool = false
    
    @State private var taskLabel: String = ""
    
    init(task content: TaskInfo) {
        task = content
        taskLabel = content.label
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: self.cardCornerRaduis)
                .foregroundColor(self.cardColor)
                .opacity(self.cardOpacity)
            VStack {
                if self.expanded {
                    TextField("\(self.task.label)", text: self.$taskLabel)
                        .padding(.leading, 5)
                        .frame(width: self.maxWidth, height: minHeight, alignment: .leading)
                        .position(x: self.maxWidth / 2, y: self.minHeight / 2)
                    HStack{
                        ButtonView(label: "Apply", width: 90, height: 40, fontSize: 15, color: Color.green) {
                            self.expanded = false
                        }
                        ButtonView(label: "Discard", width: 90, height: 40, fontSize: 15, color: Color.red) {
                            self.expanded = false
                        }
                    }
                } else {
                    Text(self.task.label)
                        .padding(.leading, 5)
                        .frame(width: self.maxWidth, height: minHeight, alignment: .leading)
                        .position(x: self.maxWidth / 2, y: self.minHeight / 2)
                        .onLongPressGesture {
                            self.expanded = true
                        }
                }
            }
            
        }
        .font(Font.system(size: self.fontSize))
        .frame(minWidth: nil, idealWidth: self.maxWidth, maxWidth: self.maxWidth,
               minHeight: self.minHeight, idealHeight: nil, maxHeight: nil,
                   alignment: .topLeading)
            .padding(.horizontal, self.horizontalPaddingSize)
            .padding(.leading, self.indentSize * CGFloat(max(self.task.level-1, 0)))
        
            
    }
    
    
    // MARK: Constants
    
    private let minHeight: CGFloat = 40
    private let maxHeight: CGFloat = 60
    private let maxWidth: CGFloat = UIScreen.main.bounds.width
    
    private let horizontalPaddingSize: CGFloat = 5
    
    private let fontSize: CGFloat = 20
    
    private let cardColor = Color.blue
    private let cardOpacity: Double = 0.5
    private let cardCornerRaduis: CGFloat = 10.0
    
    private let indentSize: CGFloat = 20
    
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: TaskInfo(id: "1", label: "test", level: 1))
    }
}
