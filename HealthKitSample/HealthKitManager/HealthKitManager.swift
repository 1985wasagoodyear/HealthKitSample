//
//  HealthKitManager.swift
//  HealthKitSample
//
//  Created by K Y on 11/5/19.
//  Copyright © 2019 K Y. All rights reserved.
//

/*
 HealthKitManager is a simple wrapper for HKHealthStore.
 
 It offers simple operations, like pedometer tracking.
 
 TO USE:
 1. begin by calling `start` method
 2. proceed with rest of use cases.
 */

import Foundation
import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    
    lazy var store: HKHealthStore = {
        return HKHealthStore()
    }()
    
    init() { }
    
    /// Begin execution of HealthKitManager here
    func start() throws {
        if HKHealthStore.isHealthDataAvailable() == false {
            throw HealthKitManagerError.unavailable
        }
        let types = Set([HKObjectType.workoutType(),
                         HKObjectType.quantityType(forIdentifier: .stepCount)!,
                         HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
        
        store.requestAuthorization(toShare: types, read: types)
        { (success, error) in
            if !success, let error = error {
                if let err = error as? HKError {
                    // TODO: handle different HKError types here.
                    fatalError("Store failed authorization with error: \(err)")
                }
                else {
                    fatalError("Store failed authorization with error: \(error)")
                }
            }
        }
        
    }
    
    /// Get the number of steps for today
    /// Remark: this gathers all steps for today, rather than individual step changes.
    func retrieveStepCount(completion: @escaping ((_ stepRetrieved: Double) -> Void)) {
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        //   Get the start of the day
        let newDate = Date.startOfCurrentDate()
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: newDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                //  Something went Wrong
                return
            }
            
            if let myResults = results{
                myResults.enumerateStatistics(from: newDate, to: Date()) {
                    (statistics, stop) in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print("Steps = \(steps)")
                        completion(steps)
                    }
                }
            }
        }
        store.execute(query)
    }
    
}
