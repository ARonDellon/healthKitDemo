# healthKitDemo

HealthKit 的第一次接入
##配置
###1、创建一个空项目

###2、在target->general里设置bundleID

###3、在target->capabilities里打开HealthKit

###4、在infoPlist里添加Privacy - Health Update Usage 		   Description和Privacy - Health Share Usage Description

###5、在需要的ViewCotroller里import HealthKit

##代码部分

> 1、HKHealthStore是整个模块的核心，先实例化一个名为healthStore的HKHealthStore对象
> 2、healthStore的isHealthDataAvailable()方法，是用来判断用户是否允许了应用访问健康数据
>3、 healthStore的requestAuthorization(_,_,_)方法，是用来发起数据的操作请求，该方法会调起健康的页面，用来手动开启或者关闭数据操作 


设置读取数据Set集
```Swift
let healthKitTypesToRead = NSSet(array:[
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,//生日
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,//血型
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,//性别
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,//体重
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,//身高
            HKObjectType.workoutType()
            ])
```

设置写入列表Set集

```Swift 
	let bodyMass = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let work = HKObjectType.workoutType()
        let writeSets = NSSet.init(array: [bodyMass!,activeEnergyBurned!,stepCount!,distanceWalkingRunning!,work])
```

发起权限请求

```Swift
healthStore?.requestAuthorization(toShare: writeSets as? Set<HKSampleType>,
                                          read: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in

	//如果成功，则会唤起授权列表，


        }

```
####完成授权以后就可以对已授权的信息进行操作了

###例如
写入步数
```Swift 
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

```

注意的是，所有的写入和读取操作都是异步的，想在UI上展示，需要回到主线程去操作UI

