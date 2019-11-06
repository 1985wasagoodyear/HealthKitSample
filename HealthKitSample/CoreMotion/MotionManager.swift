//
//  MotionManager.swift
//  HealthKitSample
//
//  Created by K Y on 11/5/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import CoreMotion


typealias MovementHandler = ()->Void

final class MotionManager {
    private let motion = CMMotionManager()
    private let update: MovementHandler
    private let interval: TimeInterval
    
    // cheap hack for now
    private var timer: Timer?
    
    init(interval: TimeInterval, _ handler: @escaping MovementHandler) {
        self.interval = interval
        update = handler
        guard motion.isAccelerometerAvailable else {
            fatalError("accelerometer not found")
        }
        motion.deviceMotionUpdateInterval = interval
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: interval,
                                     repeats: true) { [weak self] (_) in
                                        self?.update()
        }
    }
    
    // TODO: - do some smart detection on accelerometer delta for updates
    //         only when needed.
    private func startOld() {
        motion.startAccelerometerUpdates(to: .main) { [weak self] (_, error) in
            if let err = error {
                print("Was unable to receive accelerometer updates: \(err)")
            }
            self?.update()
        }
    }
    
    func stop() {
        timer?.invalidate()
        //motion.stopAccelerometerUpdates()
    }
    
    deinit {
        timer?.invalidate()
        //motion.stopAccelerometerUpdates()
    }
}
