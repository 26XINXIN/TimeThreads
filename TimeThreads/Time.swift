//
//  Time.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/18.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import Foundation

struct Time: Codable {
    private var time: Int
    
    init(_ minutes: Int) {
        time = minutes
    }
    
    init(hours: Int, minutes: Int) {
        time = hours * 60 + minutes
    }
    
    mutating func setTime(_ minutes: Int) {
        time = minutes
    }
    
    mutating func setTime(hours: Int, minutes: Int) {
        time = hours * 60 + minutes
    }
    
    mutating func add(_ other: Time) {
        time += other.time
    }
    
    func getHour() -> Int {
        time / 60
    }
    
    func getMinute() -> Int {
        time % 60
    }
    
}
