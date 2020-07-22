//
//  Slot.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/22.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

public struct Slot: Identifiable {
    /// Id
    public let id = UUID()
    /// The Icon will be displayed.
    public let image: () -> Image
    /// To allow modification on Text, wrap it with AnyView.
    public let title: () -> AnyView
    /// Tap Action
    public let action: () -> Void
    /// Style
    public let style: SlotStyle
    
    public init(
        image : @escaping () -> Image,
        title : @escaping () -> AnyView,
        action: @escaping () -> Void,
        style : SlotStyle
    ) {
        self.image = image
        self.title = title
        self.action = action
        self.style = style
    }
}

public struct SlotStyle {
    /// Background color of slot.
    public let background: Color
    /// Image tint color
    public let imageColor: Color
    /// Individual slot width
    public let slotWidth: CGFloat
    
    public init(background: Color, imageColor: Color = .white, slotWidth: CGFloat = 60) {
        self.background = background
        self.imageColor = imageColor
        self.slotWidth = slotWidth
    }
}

struct Slot_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let slots = [Slot(
            image: { Image.init(systemName: "trash") },
            title: { Text("Delete").foregroundColor(Color.white).embedInAnyView() },
            action: { },
            style: SlotStyle(background: Color.red, slotWidth: 60)
        )]
        
        return Rectangle()
            .opacity(0)
            .overlay(
                HStack(spacing: 0) {
                    
                    ForEach(slots) { slot in
                        Circle()
                            .overlay(
                                VStack(spacing: 4) {
//                                   Spacer() // To extend top edge
                                   
                                   slot.image()
                                       .resizable()
                                       .scaledToFit()
                                       .foregroundColor(slot.style.imageColor)
                                       .frame(width: slot.style.slotWidth * 0.3)
                                   
                                   slot.title()
                                    .font(.system(size: slot.style.slotWidth * 0.2))
                                   
//                                   Spacer() // To extend bottom edge
                                }
                            )
                        .frame(width: slot.style.slotWidth)
                        .foregroundColor(slot.style.background)
                    }
                }
        )
    }
}
