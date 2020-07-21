//
//  CardType.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/20.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

enum CardType: Equatable {
    case target, task, subTask
    
    static func == (lhs: CardType, rhs: CardType) -> Bool {
        switch lhs {
        case .target:
            switch rhs {
            case .target:
                return true
            case .task:
                return false
            case .subTask:
                return false
            }
        case .task:
            switch rhs {
            case .target:
                return false
            case .task:
                return true
            case .subTask:
                return false
        }
        case .subTask:
            switch rhs {
            case .target:
                return false
            case .task:
                return false
            case .subTask:
                return true
            }
        }
    }
}
