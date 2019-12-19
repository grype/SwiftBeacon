//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 12/18/19.
//

import Foundation
@testable import Beacon

class FileLoggerSpy : FileLogger {
    var invokedUrlSetter = false
    var invokedUrlSetterCount = 0
    var invokedUrl: URL?
    var invokedUrlList = [URL?]()
    var invokedUrlGetter = false
    var invokedUrlGetterCount = 0
    var stubbedUrl: URL!
    var forwardToOriginalUrl = true
    override var url: URL! {
        get {
            invokedUrlGetter = true
            invokedUrlGetterCount += 1
            if forwardToOriginalUrl {
                return super.url
            }
            return stubbedUrl
        }
    }
    var invokedNameSetter = false
    var invokedNameSetterCount = 0
    var invokedName: String?
    var invokedNameList = [String]()
    var invokedNameGetter = false
    var invokedNameGetterCount = 0
    var stubbedName: String! = ""
    var forwardToOriginalName = true
    override var name: String {
        set {
            invokedNameSetter = true
            invokedNameSetterCount += 1
            invokedName = newValue
            invokedNameList.append(newValue)
            if forwardToOriginalName {
                super.name = newValue
            }
        }
        get {
            invokedNameGetter = true
            invokedNameGetterCount += 1
            if forwardToOriginalName {
                return super.name
            }
            return stubbedName
        }
    }
    var invokedIsRunningGetter = false
    var invokedIsRunningGetterCount = 0
    var stubbedIsRunning: Bool! = false
    var forwardToOriginalIsRunning = true
    override var isRunning : Bool {
        invokedIsRunningGetter = true
        invokedIsRunningGetterCount += 1
        if forwardToOriginalIsRunning {
            return super.isRunning
        }
        return stubbedIsRunning
    }
    var invokedDescriptionGetter = false
    var invokedDescriptionGetterCount = 0
    var stubbedDescription: String! = ""
    var forwardToOriginalDescription = true
    override var description: String {
        invokedDescriptionGetter = true
        invokedDescriptionGetterCount += 1
        if forwardToOriginalDescription {
            return super.description
        }
        return stubbedDescription
    }
    var invokedNextPut = false
    var invokedNextPutCount = 0
    var invokedNextPutParameters: (aSignal: Signal, Void)?
    var invokedNextPutParametersList = [(aSignal: Signal, Void)]()
    var forwardToOriginalNextPut = true
    override func nextPut(_ aSignal: Signal) {
        invokedNextPut = true
        invokedNextPutCount += 1
        invokedNextPutParameters = (aSignal, ())
        invokedNextPutParametersList.append((aSignal, ()))
        if forwardToOriginalNextPut {
            super.nextPut(aSignal)
            return
        }
    }
    var invokedDidStart = false
    var invokedDidStartCount = 0
    var forwardToOriginalDidStart = true
    override func didStart() {
        invokedDidStart = true
        invokedDidStartCount += 1
        if forwardToOriginalDidStart {
            super.didStart()
            return
        }
    }
    var invokedDidStop = false
    var invokedDidStopCount = 0
    var forwardToOriginalDidStop = true
    override func didStop() {
        invokedDidStop = true
        invokedDidStopCount += 1
        if forwardToOriginalDidStop {
            super.didStop()
            return
        }
    }
    var invokedOpenFileForWriting = false
    var invokedOpenFileForWritingCount = 0
    var forwardToOriginalOpenFileForWriting = true
    override func openFileForWriting() {
        invokedOpenFileForWriting = true
        invokedOpenFileForWritingCount += 1
        if forwardToOriginalOpenFileForWriting {
            super.openFileForWriting()
            return
        }
    }
    var invokedCloseFile = false
    var invokedCloseFileCount = 0
    var forwardToOriginalCloseFile = true
    override func closeFile() {
        invokedCloseFile = true
        invokedCloseFileCount += 1
        if forwardToOriginalCloseFile {
            super.closeFile()
            return
        }
    }
    var invokedStart = false
    var invokedStartCount = 0
    var stubbedStartAFilterResult: (Signal, Void)?
    var forwardToOriginalStart = true
    override func start(filter aFilter: Filter? = nil) {
        invokedStart = true
        invokedStartCount += 1
        if forwardToOriginalStart {
            super.start(filter: aFilter)
            return
        }
        if let result = stubbedStartAFilterResult {
            _ = aFilter?(result.0)
        }
    }
    var invokedStartOn = false
    var invokedStartOnCount = 0
    var invokedStartOnParameters: (beacons: [Beacon], Void)?
    var invokedStartOnParametersList = [(beacons: [Beacon], Void)]()
    var stubbedStartOnAFilterResult: (Signal, Void)?
    var forwardToOriginalStartOn = true
    override func start(on beacons: [Beacon] = [Beacon.shared], filter aFilter: Filter? = nil) {
        invokedStartOn = true
        invokedStartOnCount += 1
        invokedStartOnParameters = (beacons, ())
        invokedStartOnParametersList.append((beacons, ()))
        if forwardToOriginalStartOn {
            super.start(on: beacons, filter: aFilter)
            return
        }
        if let result = stubbedStartOnAFilterResult {
            _ = aFilter?(result.0)
        }
    }
    var invokedRun = false
    var invokedRunCount = 0
    var stubbedRunDuringResult: (SignalLogger, Void)?
    var forwardToOriginalRun = true
    override func run(during: RunBlock) {
        invokedRun = true
        invokedRunCount += 1
        if forwardToOriginalRun {
            super.run(during: during)
            return
        }
        if let result = stubbedRunDuringResult {
            during(result.0)
        }
    }
    var invokedRunOn = false
    var invokedRunOnCount = 0
    var invokedRunOnParameters: (beacons: [Beacon], Void)?
    var invokedRunOnParametersList = [(beacons: [Beacon], Void)]()
    var stubbedRunOnRunBlockResult: (SignalLogger, Void)?
    var forwardToOriginalRunOn = true
    override func run(on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        invokedRunOn = true
        invokedRunOnCount += 1
        invokedRunOnParameters = (beacons, ())
        invokedRunOnParametersList.append((beacons, ()))
        if forwardToOriginalRunOn {
            super.run(on: beacons, during: runBlock)
            return
        }
        if let result = stubbedRunOnRunBlockResult {
            runBlock(result.0)
        }
    }
    var invokedRunFor = false
    var invokedRunForCount = 0
    var invokedRunForParameters: (signals: [Signal.Type], beacons: [Beacon])?
    var invokedRunForParametersList = [(signals: [Signal.Type], beacons: [Beacon])]()
    var stubbedRunForRunBlockResult: (SignalLogger, Void)?
    var forwardToOriginalRunFor = true
    override func run(for signals: [Signal.Type], on beacons: [Beacon] = [Beacon.shared], during runBlock: RunBlock) {
        invokedRunFor = true
        invokedRunForCount += 1
        invokedRunForParameters = (signals, beacons)
        invokedRunForParametersList.append((signals, beacons))
        if forwardToOriginalRunFor {
            super.run(for: signals, on: beacons, during: runBlock)
            return
        }
        if let result = stubbedRunForRunBlockResult {
            runBlock(result.0)
        }
    }
    var invokedStopOn = false
    var invokedStopOnCount = 0
    var invokedStopOnParameters: (beacons: [Beacon], Void)?
    var invokedStopOnParametersList = [(beacons: [Beacon], Void)]()
    var forwardToOriginalStopOn = true
    override func stop(on beacons: [Beacon] = [Beacon.shared]) {
        invokedStopOn = true
        invokedStopOnCount += 1
        invokedStopOnParameters = (beacons, ())
        invokedStopOnParametersList.append((beacons, ()))
        if forwardToOriginalStopOn {
            super.stop(on: beacons)
            return
        }
    }
    var invokedStop = false
    var invokedStopCount = 0
    var forwardToOriginalStop = true
    override func stop() {
        invokedStop = true
        invokedStopCount += 1
        if forwardToOriginalStop {
            super.stop()
            return
        }
    }
    var invokedNextPutAll = false
    var invokedNextPutAllCount = 0
    var invokedNextPutAllParameters: (signals: [Signal], Void)?
    var invokedNextPutAllParametersList = [(signals: [Signal], Void)]()
    var forwardToOriginalNextPutAll = true
    override func nextPutAll(_ signals: [Signal]) {
        invokedNextPutAll = true
        invokedNextPutAllCount += 1
        invokedNextPutAllParameters = (signals, ())
        invokedNextPutAllParametersList.append((signals, ()))
        if forwardToOriginalNextPutAll {
            super.nextPutAll(signals)
            return
        }
    }
    var invokedSubscribeToBeaconFilterFilter = false
    var invokedSubscribeToBeaconFilterFilterCount = 0
    var invokedSubscribeToBeaconFilterFilterParameters: (aBeacon: Beacon, Void)?
    var invokedSubscribeToBeaconFilterFilterParametersList = [(aBeacon: Beacon, Void)]()
    var stubbedSubscribeToBeaconFilterFilterFilterResult: (Signal, Void)?
    var forwardToOriginalSubscribeToBeaconFilterFilter = true
    override func subscribe(to aBeacon: Beacon, filter: Filter? = nil) {
        invokedSubscribeToBeaconFilterFilter = true
        invokedSubscribeToBeaconFilterFilterCount += 1
        invokedSubscribeToBeaconFilterFilterParameters = (aBeacon, ())
        invokedSubscribeToBeaconFilterFilterParametersList.append((aBeacon, ()))
        if forwardToOriginalSubscribeToBeaconFilterFilter {
            super.subscribe(to: aBeacon, filter: filter)
            return
        }
        if let result = stubbedSubscribeToBeaconFilterFilterFilterResult {
            _ = filter?(result.0)
        }
    }
    var invokedUnsubscribeFromBeacon = false
    var invokedUnsubscribeFromBeaconCount = 0
    var invokedUnsubscribeFromBeaconParameters: (aBeacon: Beacon, Void)?
    var invokedUnsubscribeFromBeaconParametersList = [(aBeacon: Beacon, Void)]()
    var forwardToOriginalUnsubscribeFromBeacon = true
    override func unsubscribe(from aBeacon: Beacon) {
        invokedUnsubscribeFromBeacon = true
        invokedUnsubscribeFromBeaconCount += 1
        invokedUnsubscribeFromBeaconParameters = (aBeacon, ())
        invokedUnsubscribeFromBeaconParametersList.append((aBeacon, ()))
        if forwardToOriginalUnsubscribeFromBeacon {
            super.unsubscribe(from: aBeacon)
            return
        }
    }
    var invokedUnsubscribeFromAllBeacons = false
    var invokedUnsubscribeFromAllBeaconsCount = 0
    var forwardToOriginalUnsubscribeFromAllBeacons = true
    override func unsubscribeFromAllBeacons() {
        invokedUnsubscribeFromAllBeacons = true
        invokedUnsubscribeFromAllBeaconsCount += 1
        if forwardToOriginalUnsubscribeFromAllBeacons {
            super.unsubscribeFromAllBeacons()
            return
        }
    }
}
