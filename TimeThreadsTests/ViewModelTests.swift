//
//  ViewModelTests.swift
//  TimeThreads
//
//  Created by 杨鑫 on 2020/7/20.
//  Copyright © 2020 杨鑫. All rights reserved.
//

import XCTest
@testable import TimeThreads

class ViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatingTarget() {
        let target = Target.generateTestTask()
        // test basic target information
        XCTAssertEqual(target.info.label!, "Target", "Target label is wrong")
        XCTAssertEqual(target.tasks.count, 2, "Number of task in target is not 2")
        XCTAssertEqual(target.tasks[0].info.label!, "Task 1", "Task1 label is wrong")
        XCTAssertEqual(target.tasks[1].info.label!, "Task 2", "Task2 label is wrong")
        XCTAssertEqual(target.tasks[0].subTasks.count, 1, "Number of subTasks in Task1 is not 1")
        XCTAssertEqual(target.tasks[1].subTasks.count, 0, "Number of subTasks in Task1 is not 0")
        XCTAssertEqual(target.tasks[0].subTasks[0].info.label, "SubTask 1", "SubTask 1 label is wrong")
        
        // test reassigment id identification
        for i in 0..<target.tasks.count {
            let task = target.tasks[i]
            XCTAssertEqual(task.id, target.tasks[i].id, "Task id is not same")
        }
        
        // test parent pointer
        for task in target.tasks {
            XCTAssertEqual(task.parentID, target.id, "Task's parentID is not equal to target's ID")
        }
        XCTAssertEqual(target.tasks[0].subTasks[0].parentID, target.tasks[0].id, "SubTask's parentID is not equal to task's ID")
    }
    
    func testCreatingViewModel() {
        let target = Target.generateTestTask()
        let viewModel = TaskManagerViewModel(targetList: [target])
        XCTAssert(viewModel.selectedTarget == nil, "selectedTarget is not nil")
        XCTAssert(viewModel.selectedTask == nil, "selectedTask is not nil")
        XCTAssertEqual(viewModel.taskList.count, 0, "Number of task is not 0")
        XCTAssertEqual(viewModel.subTaskList.count, 0, "Number of subTask is not 0")
        XCTAssertEqual(viewModel.targetIndex, nil, "targetIndex is not nil")
        XCTAssertEqual(viewModel.taskIndex, nil, "taskIndex is not nil")
        
        viewModel.selectTarget(id: target.id)
        XCTAssert(viewModel.selectedTarget != nil, "selectedTarget is nil")
        XCTAssertEqual(viewModel.selectedTarget!.id, target.id, "selectedTarget id doesn't match")
        XCTAssert(viewModel.selectedTask == nil, "selectedTask is not nil")
        XCTAssertEqual(viewModel.taskList.count, 2, "Number of task is not 2")
        XCTAssertEqual(viewModel.subTaskList.count, 0, "Number of subTask is not 0")
        XCTAssertEqual(viewModel.targetIndex, 0, "targetIndex is not 0")
        XCTAssertEqual(viewModel.taskIndex, nil, "taskIndex is not nil")
        
        viewModel.selectTask(id: target.tasks[0].id)
        XCTAssert(viewModel.selectedTarget != nil, "selectedTarget is nil")
        XCTAssertEqual(viewModel.selectedTarget!.id, target.id, "selectedTarget id doesn't match")
        XCTAssert(viewModel.selectedTask != nil, "selectedTask is nil")
        XCTAssertEqual(viewModel.taskList.count, 2, "Number of task is not 2")
        XCTAssertEqual(viewModel.subTaskList.count, 1, "Number of subTask is not 1")
        XCTAssertEqual(viewModel.targetIndex, 0, "targetIndex is not 0")
        XCTAssertEqual(viewModel.taskIndex, 0, "taskIndex is not 0")
        
        viewModel.unselectTask()
        XCTAssert(viewModel.selectedTarget != nil, "selectedTarget is nil")
        XCTAssertEqual(viewModel.selectedTarget!.id, target.id, "selectedTarget id doesn't match")
        XCTAssert(viewModel.selectedTask == nil, "selectedTask is not nil")
        XCTAssertEqual(viewModel.taskList.count, 2, "Number of task is not 2")
        XCTAssertEqual(viewModel.subTaskList.count, 0, "Number of subTask is not 0")
        XCTAssertEqual(viewModel.targetIndex, 0, "targetIndex is not 0")
        XCTAssertEqual(viewModel.taskIndex, nil, "taskIndex is not nil")
        
        viewModel.unselectTarget()
        XCTAssert(viewModel.selectedTarget == nil, "selectedTarget is not nil")
        XCTAssert(viewModel.selectedTask == nil, "selectedTask is not nil")
        XCTAssertEqual(viewModel.taskList.count, 0, "Number of task is not 0")
        XCTAssertEqual(viewModel.subTaskList.count, 0, "Number of subTask is not 0")
        XCTAssertEqual(viewModel.targetIndex, nil, "targetIndex is not nil")
        XCTAssertEqual(viewModel.taskIndex, nil, "taskIndex is not nil")
        
    }


}
