//
//  JRPCLoggerSpy.swift
//  
//
//  Created by Pavel Skaldin on 12/27/19.
//

import Foundation
@testable import Beacon

class JRPCLoggerSpy : JRPCLogger {
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
    var invokedUrlSessionTaskSetter = false
    var invokedUrlSessionTaskSetterCount = 0
    var invokedUrlSessionTask: URLSessionTask?
    var invokedUrlSessionTaskList = [URLSessionTask?]()
    var invokedUrlSessionTaskGetter = false
    var invokedUrlSessionTaskGetterCount = 0
    var stubbedUrlSessionTask: URLSessionTask!
    var forwardToOriginalUrlSessionTask = true
    override var urlSessionTask: URLSessionTask? {
        set {
            invokedUrlSessionTaskSetter = true
            invokedUrlSessionTaskSetterCount += 1
            invokedUrlSessionTask = newValue
            invokedUrlSessionTaskList.append(newValue)
            if forwardToOriginalUrlSessionTask {
                super.urlSessionTask = newValue
            }
        }
        get {
            invokedUrlSessionTaskGetter = true
            invokedUrlSessionTaskGetterCount += 1
            if forwardToOriginalUrlSessionTask {
                return super.urlSessionTask
            }
            return stubbedUrlSessionTask
        }
    }
    var invokedLastCompletionDateSetter = false
    var invokedLastCompletionDateSetterCount = 0
    var invokedLastCompletionDate: Date?
    var invokedLastCompletionDateList = [Date?]()
    var invokedLastCompletionDateGetter = false
    var invokedLastCompletionDateGetterCount = 0
    var stubbedLastCompletionDate: Date!
    var forwardToOriginalLastCompletionDate = true
    override var lastCompletionDate: Date? {
        set {
            invokedLastCompletionDateSetter = true
            invokedLastCompletionDateSetterCount += 1
            invokedLastCompletionDate = newValue
            invokedLastCompletionDateList.append(newValue)
            if forwardToOriginalLastCompletionDate {
                super.lastCompletionDate = newValue
            }
        }
        get {
            invokedLastCompletionDateGetter = true
            invokedLastCompletionDateGetterCount += 1
            if forwardToOriginalLastCompletionDate {
                return super.lastCompletionDate
            }
            return stubbedLastCompletionDate
        }
    }
    var invokedShouldFlushGetter = false
    var invokedShouldFlushGetterCount = 0
    var stubbedShouldFlush: Bool! = false
    var forwardToOriginalShouldFlush = true
    override var shouldFlush: Bool {
        invokedShouldFlushGetter = true
        invokedShouldFlushGetterCount += 1
        if forwardToOriginalShouldFlush {
            return super.shouldFlush
        }
        return stubbedShouldFlush
    }
    var invokedFlushIntervalSetter = false
    var invokedFlushIntervalSetterCount = 0
    var invokedFlushInterval: TimeInterval?
    var invokedFlushIntervalList = [TimeInterval]()
    var invokedFlushIntervalGetter = false
    var invokedFlushIntervalGetterCount = 0
    var stubbedFlushInterval: TimeInterval!
    var forwardToOriginalFlushInterval = true
    override var flushInterval: TimeInterval {
        set {
            invokedFlushIntervalSetter = true
            invokedFlushIntervalSetterCount += 1
            invokedFlushInterval = newValue
            invokedFlushIntervalList.append(newValue)
            if forwardToOriginalFlushInterval {
                super.flushInterval = newValue
            }
        }
        get {
            invokedFlushIntervalGetter = true
            invokedFlushIntervalGetterCount += 1
            if forwardToOriginalFlushInterval {
                return super.flushInterval
            }
            return stubbedFlushInterval
        }
    }
    var invokedQueueGetter = false
    var invokedQueueGetterCount = 0
    var stubbedQueue: DispatchQueue!
    var forwardToOriginalQueue = true
    override var queue: DispatchQueue! {
        invokedQueueGetter = true
        invokedQueueGetterCount += 1
        if forwardToOriginalQueue {
            return super.queue
        }
        return stubbedQueue
    }
    var invokedBufferSetter = false
    var invokedBufferSetterCount = 0
    var invokedBuffer: [Signal]?
    var invokedBufferList = [[Signal]]()
    var invokedBufferGetter = false
    var invokedBufferGetterCount = 0
    var stubbedBuffer: [Signal]! = []
    var forwardToOriginalBuffer = true
    override var buffer: [Signal] {
        set {
            invokedBufferSetter = true
            invokedBufferSetterCount += 1
            invokedBuffer = newValue
            invokedBufferList.append(newValue)
            if forwardToOriginalBuffer {
                super.buffer = newValue
            }
        }
        get {
            invokedBufferGetter = true
            invokedBufferGetterCount += 1
            if forwardToOriginalBuffer {
                return super.buffer
            }
            return stubbedBuffer
        }
    }
    var invokedFlushTimerSetter = false
    var invokedFlushTimerSetterCount = 0
    var invokedFlushTimer: Timer?
    var invokedFlushTimerList = [Timer?]()
    var invokedFlushTimerGetter = false
    var invokedFlushTimerGetterCount = 0
    var stubbedFlushTimer: Timer!
    var forwardToOriginalFlushTimer = true
    override var flushTimer: Timer? {
        set {
            invokedFlushTimerSetter = true
            invokedFlushTimerSetterCount += 1
            invokedFlushTimer = newValue
            invokedFlushTimerList.append(newValue)
            if forwardToOriginalFlushTimer {
                super.flushTimer = newValue
            }
        }
        get {
            invokedFlushTimerGetter = true
            invokedFlushTimerGetterCount += 1
            if forwardToOriginalFlushTimer {
                return super.flushTimer
            }
            return stubbedFlushTimer
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
    var invokedFlush = false
    var invokedFlushCount = 0
    var forwardToOriginalFlush = true
    override func flush() {
        invokedFlush = true
        invokedFlushCount += 1
        if forwardToOriginalFlush {
            super.flush()
            return
        }
    }
    var invokedCreateUrlRequest = false
    var invokedCreateUrlRequestCount = 0
    var invokedCreateUrlRequestParameters: (signals: [Signal], Void)?
    var invokedCreateUrlRequestParametersList = [(signals: [Signal], Void)]()
    var stubbedCreateUrlRequestResult: URLRequest!
    var forwardToOriginalCreateUrlRequest = true
    override func createUrlRequest(with signals: [Signal]) -> URLRequest? {
        invokedCreateUrlRequest = true
        invokedCreateUrlRequestCount += 1
        invokedCreateUrlRequestParameters = (signals, ())
        invokedCreateUrlRequestParametersList.append((signals, ()))
        if forwardToOriginalCreateUrlRequest {
            return super.createUrlRequest(with: signals)
        }
        return stubbedCreateUrlRequestResult
    }
    var invokedPerform = false
    var invokedPerformCount = 0
    var invokedPerformParameters: (urlRequest: URLRequest, Void)?
    var invokedPerformParametersList = [(urlRequest: URLRequest, Void)]()
    var stubbedPerformCompletionResult: (Bool, Void)?
    var forwardToOriginalPerform = false
    override func perform(urlRequest: URLRequest, completion:((Bool)->Void)? = nil) {
        invokedPerform = true
        invokedPerformCount += 1
        invokedPerformParameters = (urlRequest, ())
        invokedPerformParametersList.append((urlRequest, ()))
        if forwardToOriginalPerform {
            super.perform(urlRequest: urlRequest, completion: completion)
            return
        }
        if let result = stubbedPerformCompletionResult {
            completion?(result.0)
        }
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
    var invokedStartFlushTimer = false
    var invokedStartFlushTimerCount = 0
    var forwardToOriginalStartFlushTimer = true
    override func startFlushTimer() {
        invokedStartFlushTimer = true
        invokedStartFlushTimerCount += 1
        if forwardToOriginalStartFlushTimer {
            super.startFlushTimer()
            return
        }
    }
    var invokedStopFlushTimer = false
    var invokedStopFlushTimerCount = 0
    var forwardToOriginalStopFlushTimer = true
    override func stopFlushTimer() {
        invokedStopFlushTimer = true
        invokedStopFlushTimerCount += 1
        if forwardToOriginalStopFlushTimer {
            super.stopFlushTimer()
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
