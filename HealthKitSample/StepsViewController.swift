//
//  StepsViewController.swift
//  HealthKitSample
//
//  Created by K Y on 11/3/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

class StepsViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    
    @IBOutlet var stepsLabel: UILabel!
    
    // MARK: - Manager Properties
    
    lazy var m: PedometerManager = {
        return PedometerManager.init({ [weak self] steps in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stepsLabel.text = "\(steps)"
            }
        })
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m.start()
    }
}









// old, unused
extension StepsViewController {
    /*
    let healthKitManager = HealthKitManager.shared
    
    lazy var motionManager: MotionManager = {
        // get an update every 5 seconds
        return MotionManager(interval: 1.0) { [weak self] in
            guard let self = self else { return }
            self.getSteps()
        }
    }()
     
    var currQuery = ThreadsafeDispatchWorkItem()
    */
    
    // MARK: - Update UI Methods
    
    /*
     1. Query for the current step count for today
     2. Update the label once done
     */
    func getSteps() {
        if currQuery.task != nil {
            currQuery.cancel()
        }
        let task = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            self.healthKitManager.retrieveStepCount(completion: { [weak self] (steps) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    print("update")
                    self.stepsLabel.text = "\(Int(steps))"
                }
            })
        })
        currQuery.task = task
        currQuery.dispatch(to: .global())
    }

}

