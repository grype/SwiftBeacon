import Cuckoo
@testable import Beacon

import Combine
import Foundation






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
    

    
    
    
    
    public override var name: String {
        get {
            return cuckoo_manager.getter("name",
                superclassCall:
                    
                                    super.name
                    ,
                defaultCall:  __defaultImplStub!.name)
        }
        
        set {
            cuckoo_manager.setter("name",
                value: newValue,
                superclassCall:
                    
                    super.name = newValue
                    ,
                defaultCall: __defaultImplStub!.name = newValue)
        }
        
    }
    
    
    
    
    
    public override var recordings: [Signal] {
        get {
            return cuckoo_manager.getter("recordings",
                superclassCall:
                    
                                    super.recordings
                    ,
                defaultCall:  __defaultImplStub!.recordings)
        }
        
    }
    
    
    
    
    
    public override var limit: Int {
        get {
            return cuckoo_manager.getter("limit",
                superclassCall:
                    
                                    super.limit
                    ,
                defaultCall:  __defaultImplStub!.limit)
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
    
    

    

    
    
    
    
    public override func receive(subscription: Subscription)  {
        
    return cuckoo_manager.call(
    """
    receive(subscription: Subscription)
    """,
            parameters: (subscription),
            escapingParameters: (subscription),
            superclassCall:
                
                super.receive(subscription: subscription)
                ,
            defaultCall: __defaultImplStub!.receive(subscription: subscription))
        
    }
    
    
    
    
    
    public override func receive(_ input: Signal) -> Subscribers.Demand {
        
    return cuckoo_manager.call(
    """
    receive(_: Signal) -> Subscribers.Demand
    """,
            parameters: (input),
            escapingParameters: (input),
            superclassCall:
                
                super.receive(input)
                ,
            defaultCall: __defaultImplStub!.receive(input))
        
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Failure>)  {
        
    return cuckoo_manager.call(
    """
    receive(completion: Subscribers.Completion<Never>)
    """,
            parameters: (completion),
            escapingParameters: (completion),
            superclassCall:
                
                super.receive(completion: completion)
                ,
            defaultCall: __defaultImplStub!.receive(completion: completion))
        
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
        
        
        
        var name: Cuckoo.ClassToBeStubbedProperty<MockMemoryLogger, String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        
        
        
        var recordings: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockMemoryLogger, [Signal]> {
            return .init(manager: cuckoo_manager, name: "recordings")
        }
        
        
        
        
        var limit: Cuckoo.ClassToBeStubbedProperty<MockMemoryLogger, Int> {
            return .init(manager: cuckoo_manager, name: "limit")
        }
        
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMemoryLogger.self, method:
    """
    receive(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ClassStubFunction<(Signal), Subscribers.Demand> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMemoryLogger.self, method:
    """
    receive(_: Signal) -> Subscribers.Demand
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Never>)> where M1.MatchedType == Subscribers.Completion<Never> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Never>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockMemoryLogger.self, method:
    """
    receive(completion: Subscribers.Completion<Never>)
    """, parameterMatchers: matchers))
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
    
        
        
        
        var name: Cuckoo.VerifyProperty<String> {
            return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var recordings: Cuckoo.VerifyReadOnlyProperty<[Signal]> {
            return .init(manager: cuckoo_manager, name: "recordings", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var limit: Cuckoo.VerifyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "limit", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.__DoNotUse<(Subscription), Void> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(subscription: Subscription)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.__DoNotUse<(Signal), Subscribers.Demand> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: input) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(_: Signal) -> Subscribers.Demand
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(Subscribers.Completion<Never>), Void> where M1.MatchedType == Subscribers.Completion<Never> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Never>)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(completion: Subscribers.Completion<Never>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
    
    
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    
    
    
    
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
    
    

    

    
    
    
    
    public override func receive(subscription: Subscription)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive(_ input: Signal) -> Subscribers.Demand  {
        return DefaultValueRegistry.defaultValue(for: (Subscribers.Demand).self)
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Failure>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func clear()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




