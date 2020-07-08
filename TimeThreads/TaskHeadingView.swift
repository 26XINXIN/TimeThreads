//
//  TaskHeadingView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/7.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TaskHeadingView: View {
    var task: TaskInfo
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().foregroundColor(.orange)
                .padding(.horizontal, horizontalPaddingSize)
            Text(self.task.label)
                .font(Font.system(size: fontSize))
                .padding(.horizontal, horizontalPaddingSize)
        }
            .frame(minWidth: width, idealWidth: width, maxWidth: width,
                   minHeight: minHeight, idealHeight: minHeight, maxHeight: maxHeight,
                   alignment: .center)
            
    }
    
    // MARK: - Constants
    
    var width: CGFloat = UIScreen.main.bounds.width
    var minHeight: CGFloat = 30
    var maxHeight: CGFloat = 60
    var fontSize: CGFloat = 30
    
    var horizontalPaddingSize: CGFloat = 0
}

struct TaskHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHeadingView(task: TaskInfo(id: "1", label: "testtetsetsetsetstsetsetestsetsetsetsetsetestst", level: 3))
    }
}

