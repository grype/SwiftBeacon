import Cuckoo
@testable import Beacon

import Foundation



public class MockIntervalLogger: IntervalLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = IntervalLogger
    
    public typealias Stubbing = __StubbingProxy_IntervalLogger
    public typealias Verification = __VerificationProxy_IntervalLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: IntervalLogger?

    public func enableDefaultImplementation(_ stub: IntervalLogger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var flushInterval: TimeInterval {
        get {
            return cuckoo_manager.getter("flushInterval",
                superclassCall:
                    
                    super.flushInterval
                    ,
                defaultCall: __defaultImplStub!.flushInterval)
        }
        
        set {
            cuckoo_manager.setter("flushInterval",
                value: newValue,
                superclassCall:
                    
                    super.flushInterval = newValue
                    ,
                defaultCall: __defaultImplStub!.flushInterval = newValue)
        }
        
    }
    
    
    
    public override var queue: DispatchQueue! {
        get {
            return cuckoo_manager.getter("queue",
                superclassCall:
                    
                    super.queue
                    ,
                defaultCall: __defaultImplStub!.queue)
        }
        
    }
    
    
    
    public override var maxBufferSize: Int {
        get {
            return cuckoo_manager.getter("maxBufferSize",
                superclassCall:
                    
                    super.maxBufferSize
                    ,
                defaultCall: __defaultImplStub!.maxBufferSize)
        }
        
        set {
            cuckoo_manager.setter("maxBufferSize",
                value: newValue,
                superclassCall:
                    
                    super.maxBufferSize = newValue
                    ,
                defaultCall: __defaultImplStub!.maxBufferSize = newValue)
        }
        
    }
    
    
    
    public override var buffer: [Data] {
        get {
            return cuckoo_manager.getter("buffer",
                superclassCall:
                    
                    super.buffer
                    ,
                defaultCall: __defaultImplStub!.buffer)
        }
        
        set {
            cuckoo_manager.setter("buffer",
                value: newValue,
                superclassCall:
                    
                    super.buffer = newValue
                    ,
                defaultCall: __defaultImplStub!.buffer = newValue)
        }
        
    }
    
    
    
    public override var flushTimer: Timer? {
        get {
            return cuckoo_manager.getter("flushTimer",
                superclassCall:
                    
                    super.flushTimer
                    ,
                defaultCall: __defaultImplStub!.flushTimer)
        }
        
        set {
            cuckoo_manager.setter("flushTimer",
                value: newValue,
                superclassCall:
                    
                    super.flushTimer = newValue
                    ,
                defaultCall: __defaultImplStub!.flushTimer = newValue)
        }
        
    }
    
    
    
    public override var shouldFlush: Bool {
        get {
            return cuckoo_manager.getter("shouldFlush",
                superclassCall:
                    
                    super.shouldFlush
                    ,
                defaultCall: __defaultImplStub!.shouldFlush)
        }
        
    }
    

    

    
    
    
    public override func nextPut(_ aSignal: Signal)  {
        
    return cuckoo_manager.call("nextPut(_: Signal)",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.nextPut(aSignal)
                ,
            defaultCall: __defaultImplStub!.nextPut(aSignal))
        
    }
    
    
    
    public override func nextPutAll(_ signals: [Signal])  {
        
    return cuckoo_manager.call("nextPutAll(_: [Signal])",
            parameters: (signals),
            escapingParameters: (signals),
            superclassCall:
                
                super.nextPutAll(signals)
                ,
            defaultCall: __defaultImplStub!.nextPutAll(signals))
        
    }
    
    
    
    public override func encodeSignal(_ aSignal: Signal) -> Data? {
        
    return cuckoo_manager.call("encodeSignal(_: Signal) -> Data?",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.encodeSignal(aSignal)
                ,
            defaultCall: __defaultImplStub!.encodeSignal(aSignal))
        
    }
    
    
    
    public override func flush()  {
        
    return cuckoo_manager.call("flush()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.flush()
                ,
            defaultCall: __defaultImplStub!.flush())
        
    }
    
    
    
    public override func didStart(on beacons: [Beacon])  {
        
    return cuckoo_manager.call("didStart(on: [Beacon])",
            parameters: (beacons),
            escapingParameters: (beacons),
            superclassCall:
                
                super.didStart(on: beacons)
                ,
            defaultCall: __defaultImplStub!.didStart(on: beacons))
        
    }
    
    
    
    public override func didStop()  {
        
    return cuckoo_manager.call("didStop()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.didStop()
                ,
            defaultCall: __defaultImplStub!.didStop())
        
    }
    
    
    
    public override func startFlushTimer()  {
        
    return cuckoo_manager.call("startFlushTimer()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.startFlushTimer()
                ,
            defaultCall: __defaultImplStub!.startFlushTimer())
        
    }
    
    
    
    public override func stopFlushTimer()  {
        
    return cuckoo_manager.call("stopFlushTimer()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.stopFlushTimer()
                ,
            defaultCall: __defaultImplStub!.stopFlushTimer())
        
    }
    

	public struct __StubbingProxy_IntervalLogger: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var flushInterval: Cuckoo.ClassToBeStubbedProperty<MockIntervalLogger, TimeInterval> {
	        return .init(manager: cuckoo_manager, name: "flushInterval")
	    }
	    
	    
	    var queue: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockIntervalLogger, DispatchQueue?> {
	        return .init(manager: cuckoo_manager, name: "queue")
	    }
	    
	    
	    var maxBufferSize: Cuckoo.ClassToBeStubbedProperty<MockIntervalLogger, Int> {
	        return .init(manager: cuckoo_manager, name: "maxBufferSize")
	    }
	    
	    
	    var buffer: Cuckoo.ClassToBeStubbedProperty<MockIntervalLogger, [Data]> {
	        return .init(manager: cuckoo_manager, name: "buffer")
	    }
	    
	    
	    var flushTimer: Cuckoo.ClassToBeStubbedOptionalProperty<MockIntervalLogger, Timer> {
	        return .init(manager: cuckoo_manager, name: "flushTimer")
	    }
	    
	    
	    var shouldFlush: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockIntervalLogger, Bool> {
	        return .init(manager: cuckoo_manager, name: "shouldFlush")
	    }
	    
	    
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "nextPut(_: Signal)", parameterMatchers: matchers))
	    }
	    
	    func nextPutAll<M1: Cuckoo.Matchable>(_ signals: M1) -> Cuckoo.ClassStubNoReturnFunction<([Signal])> where M1.MatchedType == [Signal] {
	        let matchers: [Cuckoo.ParameterMatcher<([Signal])>] = [wrap(matchable: signals) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "nextPutAll(_: [Signal])", parameterMatchers: matchers))
	    }
	    
	    func encodeSignal<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubFunction<(Signal), Data?> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "encodeSignal(_: Signal) -> Data?", parameterMatchers: matchers))
	    }
	    
	    func flush() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "flush()", parameterMatchers: matchers))
	    }
	    
	    func didStart<M1: Cuckoo.Matchable>(on beacons: M1) -> Cuckoo.ClassStubNoReturnFunction<([Beacon])> where M1.MatchedType == [Beacon] {
	        let matchers: [Cuckoo.ParameterMatcher<([Beacon])>] = [wrap(matchable: beacons) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "didStart(on: [Beacon])", parameterMatchers: matchers))
	    }
	    
	    func didStop() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "didStop()", parameterMatchers: matchers))
	    }
	    
	    func startFlushTimer() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "startFlushTimer()", parameterMatchers: matchers))
	    }
	    
	    func stopFlushTimer() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIntervalLogger.self, method: "stopFlushTimer()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_IntervalLogger: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var flushInterval: Cuckoo.VerifyProperty<TimeInterval> {
	        return .init(manager: cuckoo_manager, name: "flushInterval", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var queue: Cuckoo.VerifyReadOnlyProperty<DispatchQueue?> {
	        return .init(manager: cuckoo_manager, name: "queue", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var maxBufferSize: Cuckoo.VerifyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "maxBufferSize", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var buffer: Cuckoo.VerifyProperty<[Data]> {
	        return .init(manager: cuckoo_manager, name: "buffer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var flushTimer: Cuckoo.VerifyOptionalProperty<Timer> {
	        return .init(manager: cuckoo_manager, name: "flushTimer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var shouldFlush: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "shouldFlush", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("nextPut(_: Signal)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func nextPutAll<M1: Cuckoo.Matchable>(_ signals: M1) -> Cuckoo.__DoNotUse<([Signal]), Void> where M1.MatchedType == [Signal] {
	        let matchers: [Cuckoo.ParameterMatcher<([Signal])>] = [wrap(matchable: signals) { $0 }]
	        return cuckoo_manager.verify("nextPutAll(_: [Signal])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func encodeSignal<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Data?> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("encodeSignal(_: Signal) -> Data?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func flush() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("flush()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didStart<M1: Cuckoo.Matchable>(on beacons: M1) -> Cuckoo.__DoNotUse<([Beacon]), Void> where M1.MatchedType == [Beacon] {
	        let matchers: [Cuckoo.ParameterMatcher<([Beacon])>] = [wrap(matchable: beacons) { $0 }]
	        return cuckoo_manager.verify("didStart(on: [Beacon])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didStop() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("didStop()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func startFlushTimer() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("startFlushTimer()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopFlushTimer() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("stopFlushTimer()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class IntervalLoggerStub: IntervalLogger {
    
    
    public override var flushInterval: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
        
        set { }
        
    }
    
    
    public override var queue: DispatchQueue! {
        get {
            return DefaultValueRegistry.defaultValue(for: (DispatchQueue?).self)
        }
        
    }
    
    
    public override var maxBufferSize: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
        set { }
        
    }
    
    
    public override var buffer: [Data] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Data]).self)
        }
        
        set { }
        
    }
    
    
    public override var flushTimer: Timer? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Timer?).self)
        }
        
        set { }
        
    }
    
    
    public override var shouldFlush: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func nextPutAll(_ signals: [Signal])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func encodeSignal(_ aSignal: Signal) -> Data?  {
        return DefaultValueRegistry.defaultValue(for: (Data?).self)
    }
    
    public override func flush()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func didStart(on beacons: [Beacon])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func didStop()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func startFlushTimer()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func stopFlushTimer()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

