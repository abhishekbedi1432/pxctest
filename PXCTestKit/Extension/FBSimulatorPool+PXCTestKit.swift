//
//  FBSimulatorPool+PXCTestKit.swift
//  pxctest
//
//  Created by Johannes Plunien on 29/12/2016.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import FBSimulatorControl
import Foundation

extension FBSimulatorPool {

    func allocateWorkers(context: AllocationContext, targets: [FBXCTestRunTarget]) throws -> [RunTestsWorker] {
        var workers: [RunTestsWorker] = []

        for target in targets {
            if context.testsToRun.count > 0 && context.testsToRun[target.name] == nil {
                continue
            }
            for simulatorConfiguration in context.simulatorConfigurations {
                try context.fileManager.createDirectoryFor(simulatorConfiguration: simulatorConfiguration, target: target.name)
                let simulator = try allocateSimulator(with: simulatorConfiguration, options: context.simulatorOptions.allocationOptions)
                let worker = RunTestsWorker(
                    name: target.name,
                    applications: target.applications,
                    simulator: simulator,
                    testLaunchConfiguration: target.testLaunchConfiguration
                )
                workers.append(worker)
            }
        }
        return workers
    }

}
