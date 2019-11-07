//
//  PedometerManager.swift
//  HealthKitSample
//
//  Created by K Y on 11/6/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import CoreMotion

// https://www.devfright.com/how-to-use-the-cmpedometer-for-counting-steps/


typealias PedometerHandler = (Int)->Void

final class PedometerManager {
    private let manager = CMPedometer()
    private let update: PedometerHandler
    
    init(_ handler: @escaping PedometerHandler) {guard CMPedometer.isStepCountingAvailable() else {
            fatalError("pedometer not available")
        }
        self.update = handler
    }
    
    func start() {
        manager.startUpdates(from: .startOfCurrentDate()) { [weak self] (data, err) in
            guard let self = self,
            let steps = data?.numberOfSteps.intValue else { return }
            self.update(steps)
        }
    }
    
    func stop() {
        manager.stopUpdates()
    }
    
    deinit {
        manager.stopUpdates()
    }
    
}
