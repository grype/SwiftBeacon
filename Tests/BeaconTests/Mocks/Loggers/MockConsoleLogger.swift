import Cuckoo
@testable import Beacon

import Combine
import Foundation






public class MockConsoleLogger: ConsoleLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = ConsoleLogger
    
    public typealias Stubbing = __StubbingProxy_ConsoleLogger
    public typealias Verification = __VerificationProxy_ConsoleLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ConsoleLogger?

    public func enableDefaultImplementation(_ stub: ConsoleLogger) {
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
        
    }
    
    
    
    
    
    public override var markedInactvitiyPeriod: TimeInterval {
        get {
            return cuckoo_manager.getter("markedInactvitiyPeriod",
                superclassCall:
                    
                                    super.markedInactvitiyPeriod
                    ,
                defaultCall:  __defaultImplStub!.markedInactvitiyPeriod)
        }
        
        set {
            cuckoo_manager.setter("markedInactvitiyPeriod",
                value: newValue,
                superclassCall:
                    
                    super.markedInactvitiyPeriod = newValue
                    ,
                defaultCall: __defaultImplStub!.markedInactvitiyPeriod = newValue)
        }
        
    }
    
    
    
    
    
    public override var inactivityDelimiter: String {
        get {
            return cuckoo_manager.getter("inactivityDelimiter",
                superclassCall:
                    
                                    super.inactivityDelimiter
                    ,
                defaultCall:  __defaultImplStub!.inactivityDelimiter)
        }
        
        set {
            cuckoo_manager.setter("inactivityDelimiter",
                value: newValue,
                superclassCall:
                    
                    super.inactivityDelimiter = newValue
                    ,
                defaultCall: __defaultImplStub!.inactivityDelimiter = newValue)
        }
        
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
    
    

    public struct __StubbingProxy_ConsoleLogger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var name: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockConsoleLogger, String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        
        
        
        var markedInactvitiyPeriod: Cuckoo.ClassToBeStubbedProperty<MockConsoleLogger, TimeInterval> {
            return .init(manager: cuckoo_manager, name: "markedInactvitiyPeriod")
        }
        
        
        
        
        var inactivityDelimiter: Cuckoo.ClassToBeStubbedProperty<MockConsoleLogger, String> {
            return .init(manager: cuckoo_manager, name: "inactivityDelimiter")
        }
        
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ClassStubFunction<(Signal), Subscribers.Demand> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockConsoleLogger.self, method:
    """
    receive(_: Signal) -> Subscribers.Demand
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Never>)> where M1.MatchedType == Subscribers.Completion<Never> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Never>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockConsoleLogger.self, method:
    """
    receive(completion: Subscribers.Completion<Never>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockConsoleLogger.self, method:
    """
    receive(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockConsoleLogger.self, method:
    """
    nextPut(_: Signal)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_ConsoleLogger: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var name: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var markedInactvitiyPeriod: Cuckoo.VerifyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "markedInactvitiyPeriod", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var inactivityDelimiter: Cuckoo.VerifyProperty<String> {
            return .init(manager: cuckoo_manager, name: "inactivityDelimiter", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.__DoNotUse<(Subscription), Void> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(subscription: Subscription)
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
        
        
    }
}


public class ConsoleLoggerStub: ConsoleLogger {
    
    
    
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public override var markedInactvitiyPeriod: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var inactivityDelimiter: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func receive(_ input: Signal) -> Subscribers.Demand  {
        return DefaultValueRegistry.defaultValue(for: (Subscribers.Demand).self)
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Failure>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive(subscription: Subscription)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




