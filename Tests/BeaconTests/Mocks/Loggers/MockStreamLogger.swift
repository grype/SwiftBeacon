import Cuckoo
@testable import Beacon

import Foundation



public class MockStreamLogger: StreamLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = StreamLogger
    
    public typealias Stubbing = __StubbingProxy_StreamLogger
    public typealias Verification = __VerificationProxy_StreamLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: StreamLogger?

    public func enableDefaultImplementation(_ stub: StreamLogger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var writer: EncodedStreamSignalWriter {
        get {
            return cuckoo_manager.getter("writer",
                superclassCall:
                    
                    super.writer
                    ,
                defaultCall: __defaultImplStub!.writer)
        }
        
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
    
    
    
    public override func nextPut(_ aSignal: Signal)  {
        
    return cuckoo_manager.call("nextPut(_: Signal)",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.nextPut(aSignal)
                ,
            defaultCall: __defaultImplStub!.nextPut(aSignal))
        
    }
    

	public struct __StubbingProxy_StreamLogger: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var writer: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStreamLogger, EncodedStreamSignalWriter> {
	        return .init(manager: cuckoo_manager, name: "writer")
	    }
	    
	    
	    func didStart<M1: Cuckoo.Matchable>(on beacons: M1) -> Cuckoo.ClassStubNoReturnFunction<([Beacon])> where M1.MatchedType == [Beacon] {
	        let matchers: [Cuckoo.ParameterMatcher<([Beacon])>] = [wrap(matchable: beacons) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method: "didStart(on: [Beacon])", parameterMatchers: matchers))
	    }
	    
	    func didStop() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method: "didStop()", parameterMatchers: matchers))
	    }
	    
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method: "nextPut(_: Signal)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_StreamLogger: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var writer: Cuckoo.VerifyReadOnlyProperty<EncodedStreamSignalWriter> {
	        return .init(manager: cuckoo_manager, name: "writer", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("nextPut(_: Signal)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class StreamLoggerStub: StreamLogger {
    
    
    public override var writer: EncodedStreamSignalWriter {
        get {
            return DefaultValueRegistry.defaultValue(for: (EncodedStreamSignalWriter).self)
        }
        
    }
    

    

    
    public override func didStart(on beacons: [Beacon])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func didStop()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

