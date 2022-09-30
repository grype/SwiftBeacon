import Cuckoo
@testable import Beacon

import Foundation
import RWLock






public class MockMemoryLogger: MemoryLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = MemoryLogger
    
    public typealias Stubbing = __StubbingProxy_MemoryLogger
    public typealias Verification = __VerificationProxy_MemoryLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: MemoryLogger?

    public func enableDefaultImplementation(_ stub: MemoryLogger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var recordings: [Signal] {
        get {
            return cuckoo_manager.getter("recordings",
                superclassCall:
                    
                    super.recordings
                    ,
                defaultCall: __defaultImplStub!.recordings)
        }
        
    }
    
    
    
    
    
    public override var limit: Int {
        get {
            return cuckoo_manager.getter("limit",
                superclassCall:
                    
                    super.limit
                    ,
                defaultCall: __defaultImplStub!.limit)
        }
        
        set {
            cuckoo_manager.setter("limit",
                value: newValue,
                superclassCall:
                    
                    super.limit = newValue
                    ,
                defaultCall: __defaultImplStub!.limit = newValue)
        }
        
    }
    
    

    

    
    
    
    
    public override func nextPut(_ aSignal: Signal)  {
        
    return cuckoo_manager.call(
    """
    nextPut(_: Signal)
    """,
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.nextPut(aSignal)
                ,
            defaultCall: __defaultImplStub!.nextPut(aSignal))
        
    }
    
    
    
    
    
    public override func clear()  {
        
    return cuckoo_manager.call(
    """
    clear()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.clear()
                ,
            defaultCall: __defaultImplStub!.clear())
        
    }
    
    

    public struct __StubbingProxy_MemoryLogger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var recordings: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockMemoryLogger, [Signal]> {
            return .init(manager: cuckoo_manager, name: "recordings")
        }
        
        
        
        
        var limit: Cuckoo.ClassToBeStubbedProperty<MockMemoryLogger, Int> {
            return .init(manager: cuckoo_manager, name: "limit")
        }
        
        
        
        
        
        func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMemoryLogger.self, method:
    """
    nextPut(_: Signal)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clear() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockMemoryLogger.self, method:
    """
    clear()
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_MemoryLogger: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var recordings: Cuckoo.VerifyReadOnlyProperty<[Signal]> {
            return .init(manager: cuckoo_manager, name: "recordings", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var limit: Cuckoo.VerifyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "limit", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return cuckoo_manager.verify(
    """
    nextPut(_: Signal)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clear() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clear()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class MemoryLoggerStub: MemoryLogger {
    
    
    
    
    public override var recordings: [Signal] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Signal]).self)
        }
        
    }
    
    
    
    
    
    public override var limit: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func clear()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




