//
//  SlidableModifier.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/22.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import SwiftUI

public struct SlidableModifier: ViewModifier {
    
    public enum SlideAxis {
        case left2Right
        case right2Left
    }
    
    private var contentOffset: CGSize {
        switch self.slideAxis {
        case .left2Right:
            return .init(width: self.currentSlotsWidth, height: 0)
        case .right2Left:
            return .init(width: -self.currentSlotsWidth, height: 0)
        }
    }
    
    private var slotOffset: CGSize {
        switch self.slideAxis {
        case .left2Right:
            return .init(width: self.currentSlotsWidth - self.totalSlotWidth, height: 0)
        case .right2Left:
            return .init(width: self.totalSlotWidth - self.currentSlotsWidth, height: 0)
        }
    }
    
    private var zStackAlignment: Alignment {
        switch self.slideAxis {
        case .left2Right:
            return .leading
        case .right2Left:
            return .trailing
        }
    }
    
    /// Animated slot widths of total
    @State var currentSlotsWidth: CGFloat = 0
    
    /// To restrict the bounds of slots
    private func optWidth(value: CGFloat) -> CGFloat {
        return min(abs(value), totalSlotWidth)
    }
    
    var animatableData: Double {
        get { Double(self.currentSlotsWidth) }
        set { self.currentSlotsWidth = CGFloat(newValue) }
    }
    
    private var totalSlotWidth: CGFloat {
        return slots.map { $0.style.slotWidth }.reduce(0, +) + 30
    }
    
    private var slots: [Slot]
    private var slideAxis: SlideAxis
    
    public init(slots: [Slot], slideAxis: SlideAxis) {
        self.slots = slots
        self.slideAxis = slideAxis
    }
    
    private func flushState() {
        withAnimation {
            self.currentSlotsWidth = 0
        }
    }
    
    public func body(content: Content) -> some View {
        
        ZStack(alignment: self.zStackAlignment) {
            
            content
                .offset(self.contentOffset)
                .onTapGesture(perform: flushState)
            
            Rectangle()
                .opacity(0)
                .overlay(
                    HStack(spacing: 10) {
                        
                        ForEach(self.slots) { slot in
                            Circle()
                                .overlay(
                                VStack(spacing: 4) {
                                    slot.image()
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(slot.style.imageColor)
                                        .frame(width: slot.style.slotWidth * 0.3)
                                    
                                    slot.title()
                                        .foregroundColor(slot.style.imageColor)
                                        .font(.system(size: slot.style.slotWidth * 0.2))
                                }
                            )
                            
                            .frame(width: slot.style.slotWidth)
                            .foregroundColor(slot.style.background)
                            .onTapGesture {
                                slot.action()
                                self.flushState()
                            }
                        }
                    }
            )
            .offset(self.slotOffset)
            .frame(width: self.totalSlotWidth)
            
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    let amount = value.translation.width
                    
                    if self.slideAxis == .left2Right {
                        if amount < 0 { return }
                    } else {
                        if amount > 0 { return }
                    }
                    
                    self.currentSlotsWidth = self.optWidth(value: amount)
            }
            .onEnded { value in
                withAnimation {
                    if self.currentSlotsWidth < (self.totalSlotWidth / 2) {
                        self.currentSlotsWidth = 0
                    } else {
                        self.currentSlotsWidth = self.totalSlotWidth
                    }
                }
            }
        )
        
    }
    
}

extension View {
    
    func swipeLeft2Right(slots: [Slot]) -> some View {
        return self.modifier(SlidableModifier(slots: slots, slideAxis: .left2Right))
    }
    
    func swipeRight2Left(slots: [Slot]) -> some View {
        return self.modifier(SlidableModifier(slots: slots, slideAxis: .right2Left))
    }
    
    func embedInAnyView() -> AnyView {
        return AnyView ( self )
    }
}
