//
//  TargetView.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/7.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

struct TargetView: View {
    var target: Target
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().foregroundColor(.orange)
            Text(self.target.label)
                .font(Font.system(size: fontSize))
        }
        .frame(width: width, height: height, alignment: .center)
            
    }
    
    // MARK: - Constants
    
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = 80
    var fontSize: CGFloat = 40

}

struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetView(target: Target(label: "test"))
    }
}

