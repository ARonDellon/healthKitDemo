//
//  ViewController.swift
//  healthKitDemo
//
//  Created by wangweiyi on 2017/2/17.
//  Copyright © 2017年 wwy. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI

class ViewController: UIViewController {

    var healthStore: HKHealthStore?
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.healthStore = HKHealthStore()




    }

    func authorizeHealthKit(completion: @escaping ((_ success:Bool, _ error:NSError?) -> ()))
    {
        // 1. Set the types you want to read from HK Store

        
        let healthKitTypesToRead = NSSet(array:[
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKObjectType.workoutType()
            ])

        // 2. Set the types you want to write to HK Store



        let bodyMass = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let work = HKObjectType.workoutType()
        let writeSets = NSSet.init(array: [bodyMass!,activeEnergyBurned!,stepCount!,distanceWalkingRunning!,work])

        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])


            completion(false, error)

            return;
        }

        // 4.  Request HealthKit authorization

        healthStore?.requestAuthorization(toShare: writeSets as? Set<HKSampleType>,
                                          read: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in

                                            completion(success, error as NSError?)


        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func getCick(_ sender: Any) {
        self.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }

    @IBAction func setClick(_ sender: Any) {

        let setpCountType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let unit = HKUnit.count()
        let quantity = HKQuantity.init(unit: unit, doubleValue: 2000)
        let now = Date.init(timeIntervalSinceNow: 0)
        let sample = HKQuantitySample.init(type: setpCountType!, quantity: quantity, start: now, end: now)

        self.healthStore?.save(sample, withCompletion: { (success, error) in
            if success {
                DispatchQueue.main.async() {

                    self.label.text = "写入步数2000\(success)"

                }
            }
        })

        let stepDistance = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let dUnit = HKUnit.meter()
        let dQuantity = HKQuantity.init(unit: dUnit, doubleValue: 1000)
        let dSample = HKQuantitySample.init(type: stepDistance!, quantity: dQuantity, start: now, end: now)



        self.healthStore?.save(dSample, withCompletion: { (success, error) in
            if success {
                DispatchQueue.main.async() {
                    self.label.text = "写入距离1000\(success)"
                }

            }
        })


    }
}

