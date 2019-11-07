//
//  ThreadsafeDispatchWorkItem.swift
//  HealthKitSample
//
//  Created by K Y on 11/5/19.
//  Copyright © 2019 K Y. All rights reserved.
//

/********************************
*
*   EXPERIMENTAL.
*
********************************/

import Foundation

class ThreadsafeDispatchWorkItem {
    
    private var _task: DispatchWorkItem?
    private let queue = DispatchQueue.global()
    
    var task: DispatchWorkItem? {
        set {
            queue.sync(flags: .barrier) {
                self.cancel()
                _task = newValue
            }
        }
        get {
            return queue.sync(flags: .barrier) {
                _task
            }
        }
    }
    
    func cancel() {
        queue.sync(flags: .barrier) {
            self.task?.cancel()
        }
    }
    
    func dispatch(to queue: DispatchQueue) {
        if let task = task {
            queue.async(execute: task)
        }
    }
    
}
