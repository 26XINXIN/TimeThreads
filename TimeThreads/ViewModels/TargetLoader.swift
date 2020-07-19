//
//  TargetLoader.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/19.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation
import SwiftUI

struct TargetLoader {
    @Binding var selectedTarget: Target? {
        didSet {}
    }
    @Binding var TaskList: [Task]
    
    
}
