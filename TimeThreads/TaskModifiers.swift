//
//  TaskModifiers.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/6.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

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

struct Headify: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Rectangle().foregroundColor(.orange)
                content
            }
        }
    }
}

extension View {
    func cardify() -> some View {
        self.modifier(Cardify())
    }
    
    func headify() -> some View {
        self.modifier(Headify())
    }
}
