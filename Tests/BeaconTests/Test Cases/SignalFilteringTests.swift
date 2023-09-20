//
//  SignalFilteringTests.swift
//
//
//  Created by Pavel Skaldin on 9/16/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Beacon
import Nimble
import XCTest

private class TestSubsignal: WrapperSignal {}

class SignalFilteringTests: XCTestCase {
    private var firstLogger: MemoryLogger!
    private var secondLogger: MemoryLogger!
    
    private var firstBeacon: Beacon!
    private var secondBeacon: Beacon!
    
    override func setUp() {
        super.setUp()
        firstBeacon = Beacon()
        secondBeacon = Beacon()
        
        firstLogger = MemoryLogger(name: "Test Logger 1")
        firstLogger.beForTesting()
        
        secondLogger = MemoryLogger(name: "Test Logger 2")
        secondLogger.beForTesting()
        
        Constraint.enableAllSignals()
    }
    
    override func tearDown() {
        super.tearDown()
        if firstLogger.isRunning {
            firstLogger.stop()
        }
        if secondLogger.isRunning {
            secondLogger.stop()
        }
    }
    
    // MARK: - Enabling/Disabling All
    
    func testEnablingAllSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.enableAllSignals()
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingAllSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.disableAllSignals()
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    // MARK: - Constraint Building
    
    func testEnabledConstraintSugar() {
        expect(+Signal.self).to(equal(Constraint(signalType: Signal.self, state: .enabled)))
    }
    
    func testDisabledConstraintSugar() {
        expect(-Signal.self).to(equal(Constraint(signalType: Signal.self, state: .disabled)))
    }
    
    func testConstraintLoggerOverloadSugar() {
        let constraint = +Signal.self ~> firstLogger
        expect(constraint).to(equal(Constraint(signalType: Signal.self, state: .enabled, logger: firstLogger)))
    }
    
    func testConstraintBeaconOverloadSugar() {
        let constraint = +Signal.self ~> firstBeacon
        expect(constraint).to(equal(Constraint(signalType: Signal.self, state: .enabled, beacon: firstBeacon)))
    }
    
    func testConstraintLoggerAndBeaconOverloadSugar() {
        let constraint = +Signal.self ~> (firstLogger, firstBeacon)
        expect(constraint).to(equal(Constraint(signalType: Signal.self, state: .enabled, logger: firstLogger, beacon: firstBeacon)))
    }
    
    // MARK: - Emitting
    
    func testEmitsWhenEnabled() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
        }
        emit(on: firstBeacon)
        expect(self.firstLogger.recordings.count) == 1
        expect(self.firstLogger.recordings.first!).to(beAKindOf(ContextSignal.self))
    }
    
    func testDoesNotEmitWhenDisabled() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
        }
        emit(on: firstBeacon)
        expect(self.firstLogger.recordings).to(beEmpty())
    }
    
    func testEmitsMultipleOnSingleLogger() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +StringSignal.self ~> firstLogger
            +ContextSignal.self ~> firstLogger
        }
        emit("String", on: [firstBeacon, secondBeacon])
        emit(on: [firstBeacon, secondBeacon])
        emit(123, on: [firstBeacon, secondBeacon]) // this should not be emitted
        expect(self.firstLogger.recordings.count) == 2
    }
    
    func testEmitsMultipleOnSingleBeacon() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +StringSignal.self ~> firstBeacon
            +ContextSignal.self ~> firstBeacon
        }
        emit("String", on: [firstBeacon, secondBeacon])
        emit(on: [firstBeacon, secondBeacon])
        emit(123, on: [firstBeacon, secondBeacon]) // this should not be emitted
        expect(self.firstLogger.recordings.count) == 2
    }
    
    func testEmitsMultipleOnDifferentLoggers() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +StringSignal.self ~> firstLogger
            +ContextSignal.self ~> secondLogger
        }
        emit("String", on: [firstBeacon, secondBeacon])
        emit(on: [firstBeacon, secondBeacon])
        emit(123, on: [firstBeacon, secondBeacon]) // this should not be emitted
        expect(self.firstLogger.recordings.count) == 1
        expect(self.secondLogger.recordings.count) == 1
        expect(self.firstLogger.recordings.first!).to(beAKindOf(StringSignal.self))
        expect(self.secondLogger.recordings.first!).to(beAKindOf(ContextSignal.self))
    }
    
    func testEmitsMultipleOnDifferentBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +StringSignal.self ~> firstBeacon
            +ContextSignal.self ~> secondBeacon
        }
        emit("String", on: [firstBeacon, secondBeacon])
        emit(on: [firstBeacon, secondBeacon])
        emit(123, on: [firstBeacon, secondBeacon]) // this should not be emitted
        expect(self.firstLogger.recordings.count) == 1
        expect(self.secondLogger.recordings.count) == 1
        expect(self.firstLogger.recordings.first!).to(beAKindOf(StringSignal.self))
        expect(self.secondLogger.recordings.first!).to(beAKindOf(ContextSignal.self))
    }
    
    func testEmitsMultipleOnDifferentLoggerAndBeacon() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +StringSignal.self ~> firstLogger
            +ContextSignal.self ~> secondBeacon
        }
        emit("String", on: [firstBeacon, secondBeacon])
        emit(on: [firstBeacon, secondBeacon])
        emit(123, on: [firstBeacon, secondBeacon]) // this should not be emitted
        expect(self.firstLogger.recordings.count) == 1
        expect(self.secondLogger.recordings.count) == 1
        expect(self.firstLogger.recordings.first!).to(beAKindOf(StringSignal.self))
        expect(self.secondLogger.recordings.first!).to(beAKindOf(ContextSignal.self))
    }
    
    func testDoesNotEmitUnwantedSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
        }
        emit("String", on: firstBeacon)
        expect(self.firstLogger.recordings).to(beEmpty())
    }
    
    // MARK: - Constraints: Signals
    
    func testEnablingConcreteSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingConcreteSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingHierarchyOfSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +WrapperSignal.self ~> firstBeacon
        }
        expectToLogHierarchy(of: WrapperSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingHierarchyOfSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -WrapperSignal.self ~> firstBeacon
        }
        expectToLogAllButHierarchy(of: WrapperSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingMultipleSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
            +StringSignal.self ~> firstBeacon
        }
        expectToLog(ContextSignal.self, on: [firstBeacon])
        expectToLog(StringSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingMultipleSignals() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
            -StringSignal.self ~> firstBeacon
        }
        expectToLogAllBut([ContextSignal.self, StringSignal.self], on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingMultipleSignalsOnDifferentBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
            +StringSignal.self ~> secondBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogOnly(StringSignal.self, on: [secondBeacon])
    }
    
    func testDisablingMultipleSignalsOnDifferentBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
            -StringSignal.self ~> secondBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogAllBut(StringSignal.self, on: [secondBeacon])
    }
    
    func testEnablingBaseSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
        }
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingBaseSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
        }
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingBaseSignalOnMultipleBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
        }
        expectToLogAllSignals(on: [firstBeacon, secondBeacon])
    }
    
    func testDisablingBaseSignalOnMultipleBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
        }
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingBaseAndSubSignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            +ContextSignal.self
        }
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingBaseAndSubsignal() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            -ContextSignal.self
        }
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingBaseMultipleTimes() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            +Signal.self
            +ContextSignal.self
        }
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingBaseMultipleTimes() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            -Signal.self
            -ContextSignal.self
        }
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingSubsignalMultipleTimes() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            +ContextSignal.self
            +ContextSignal.self
        }
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingSubsignalMultipleTimes() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            -ContextSignal.self
            -ContextSignal.self
        }
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingAfterDisabling() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self
            +ContextSignal.self
        }
        expectToLogAllSignals(on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingAfterEnabling() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +Signal.self
            -Signal.self
        }
        expectToLogNoSignals(on: [firstBeacon, secondBeacon])
    }
    
    // MARK: - Constraints: Logger
    
    func testEnablingConcreteLogger() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstLogger
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingConcreteLogger() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingOnMultipleLoggers() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstLogger
            +ContextSignal.self ~> secondLogger
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon, secondBeacon])
    }
    
    func testDisablingOnMultipleLoggers() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstLogger
            -ContextSignal.self ~> secondLogger
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingOnSomeLoggers() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstLogger
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingOnSomeLoggers() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstLogger
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogAllSignals(on: [secondBeacon])
    }
    
    // MARK: - Constraints: Beacon
    
    func testEnablingConcreteBeacon() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingConcreteBeacon() {
        firstLogger.start(on: [firstBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testEnablingOnMultipleBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
            +ContextSignal.self ~> secondBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon, secondBeacon])
    }
    
    func testDisablingOnMultipleBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
            -ContextSignal.self ~> secondBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon, secondBeacon])
    }
    
    func testEnablingOnSomeBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingOnSomeBeacons() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogAllSignals(on: [secondBeacon])
    }
    
    // MARK: - Constraints: Logger & Beacon
    
    func testEnablingOnConcreteLoggerAndBeacon() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> (firstLogger, firstBeacon)
        }
        Constraint.disableAllSignals()
        ContextSignal.enable(constrainedTo: firstLogger, on: firstBeacon)
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingOnConcreteLoggerAndBeacon() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> (firstLogger, firstBeacon)
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogAllSignals(on: [secondBeacon])
    }
    
    func testEnablingInParts() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            -Signal.self
            +ContextSignal.self ~> firstLogger
            +ContextSignal.self ~> firstBeacon
        }
        expectToLogOnly(ContextSignal.self, on: [firstBeacon])
        expectToLogNoSignals(on: [secondBeacon])
    }
    
    func testDisablingInParts() {
        firstLogger.start(on: [firstBeacon])
        secondLogger.start(on: [secondBeacon])
        Constraint.clearAndActivate {
            +Signal.self
            -ContextSignal.self ~> firstLogger
            -ContextSignal.self ~> firstBeacon
        }
        expectToLogAllBut(ContextSignal.self, on: [firstBeacon])
        expectToLogAllSignals(on: [secondBeacon])
    }
    
    // MARK: - Helpers
    
    private func expectToLogAllSignals(on beacons: [Beacon]) {
        beacons.forEach { beacon in
            expect(willEmit(type: Signal.self, on: beacon)).to(beTrue())
            expect(willEmit(type: ContextSignal.self, on: beacon)).to(beTrue())
            expect(willEmit(type: StringSignal.self, on: beacon)).to(beTrue())
            expect(willEmit(type: WrapperSignal.self, on: beacon)).to(beTrue())
            expect(willEmit(type: TestSubsignal.self, on: beacon)).to(beTrue())
        }
    }
    
    private func expectTologOnlyBaseSignal(on beacons: [Beacon]) {
        beacons.forEach { beacon in
            expect(willEmit(type: Signal.self, on: beacon)).to(beTrue())
            expect(willEmit(type: ContextSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: StringSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: WrapperSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: TestSubsignal.self, on: beacon)).to(beFalse())
        }
    }
    
    private func expectToLog<T: Signal>(_ signalType: T.Type, on beacons: [Beacon]) {
        beacons.forEach { beacon in
            expect(willEmit(type: signalType, on: beacon)).to(beTrue())
        }
    }
    
    private func expectToLogOnly<T: Signal>(_ signalType: T.Type, on beacons: [Beacon]) {
        let others = [Signal.self, ContextSignal.self, StringSignal.self, WrapperSignal.self, TestSubsignal.self].filter { $0 !== signalType }
        beacons.forEach { beacon in
            others.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beFalse())
            }
            expect(willEmit(type: signalType, on: beacon)).to(beTrue())
        }
    }
    
    private func expectToLogHierarchy<T: Signal>(of signalType: T.Type, on beacons: [Beacon]) {
        let ours: [Signal.Type] = signalType.withAllSubclasses as! [Signal.Type]
        let others: [Signal.Type] = [Signal.self, ContextSignal.self, StringSignal.self, WrapperSignal.self, TestSubsignal.self].filter { aClass in
            !ours.contains { $0 == aClass }
        }
        beacons.forEach { beacon in
            others.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beFalse())
            }
            ours.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beTrue())
            }
        }
    }
    
    private func expectToLogAllButHierarchy<T: Signal>(of signalType: T.Type, on beacons: [Beacon]) {
        let ours: [Signal.Type] = signalType.withAllSubclasses as! [Signal.Type]
        let others: [Signal.Type] = [Signal.self, ContextSignal.self, StringSignal.self, WrapperSignal.self, TestSubsignal.self].filter { aClass in
            !ours.contains { $0 == aClass }
        }
        beacons.forEach { beacon in
            others.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beTrue())
            }
            ours.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beFalse())
            }
        }
    }
    
    private func expectToLogAllBut<T: Signal>(_ signalType: T.Type, on beacons: [Beacon]) {
        let others = [Signal.self, ContextSignal.self, StringSignal.self, WrapperSignal.self, TestSubsignal.self].filter { $0 !== signalType }
        beacons.forEach { beacon in
            others.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beTrue())
            }
            expect(willEmit(type: signalType, on: beacon)).to(beFalse())
        }
    }
    
    private func expectToLogAllBut(_ signalTypes: [Signal.Type], on beacons: [Beacon]) {
        let others: [Signal.Type] = [Signal.self, ContextSignal.self, StringSignal.self, WrapperSignal.self, TestSubsignal.self].filter { aClass in
            !signalTypes.contains { $0 == aClass }
        }
        beacons.forEach { beacon in
            others.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beTrue())
            }
            signalTypes.forEach { aType in
                expect(willEmit(type: aType, on: beacon)).to(beFalse())
            }
        }
    }
    
    private func expectToLogNoSignals(on beacons: [Beacon]) {
        beacons.forEach { beacon in
            expect(willEmit(type: Signal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: ContextSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: StringSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: WrapperSignal.self, on: beacon)).to(beFalse())
            expect(willEmit(type: TestSubsignal.self, on: beacon)).to(beFalse())
        }
    }
}
