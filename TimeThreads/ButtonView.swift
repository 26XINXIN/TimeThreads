//
//  ButtomView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/7.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    var label: String
    var width: CGFloat
    var height: CGFloat
    var fontSize: CGFloat
    var color: Color
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRaduis)
                .foregroundColor(color)
            Text(label)
                .font(Font.system(size: fontSize))
        }
            .frame(width: width, height: height, alignment: .center)
        .onTapGesture {
            self.action()
        }
    }
    
    private let cornerRaduis: CGFloat = 15
}

struct ButtomView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(label: "OK", width: 50, height: 40, fontSize: 15, color: Color.green) {}
    }
}
