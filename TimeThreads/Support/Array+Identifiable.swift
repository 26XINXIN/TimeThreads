//
//  Array+Identifiable.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/19.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func indexByID(_ id: Element.ID) -> Int? {
        firstIndex(where: { $0.id == id })
    }
}
