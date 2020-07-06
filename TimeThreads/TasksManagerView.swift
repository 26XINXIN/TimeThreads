//
//  TasksManagerView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/5.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TasksManagerView: View {
    @ObservedObject var manager: TaskManagerController
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                ForEach(self.manager.listTasks(), id: \.id) { task in
                        TaskView(task: task)
                            .frame(minWidth: nil, idealWidth: self.screenWidth - 10, maxWidth: self.screenWidth - 10, minHeight: self.lineHeight, idealHeight: self.lineHeight, maxHeight: 2 * self.lineHeight, alignment: .topLeading)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Constant(s)
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let lineHeight: CGFloat = 40.0
}


struct TaskView: View {
    var task: TaskInfo
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(uiImage: UIImage(systemName: "rays")!)
                Text(self.task.label).cardify()
            }
            .frame(minWidth: nil, idealWidth: geometry.size.width - 10, maxWidth: geometry.size.width - 10, minHeight: geometry.size.height, idealHeight: geometry.size.height, maxHeight: 2 * geometry.size.height, alignment: .topLeading)
            .padding(5)
            .padding(.leading, 20 * CGFloat(self.task.level))
        }
        
    }
    

    
    
}


struct Cardify: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.blue)
                .opacity(0.5)
            content
                .padding(5)
            
        }
        .frame(height: 40)
        .padding(3)
    }
}

extension View {
    func cardify() -> some View {
        self.modifier(Cardify())
    }
}



struct TasksManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TasksManagerView(manager: TaskManagerController())
    }
}
