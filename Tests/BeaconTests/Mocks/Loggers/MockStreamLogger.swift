import Cuckoo
@testable import Beacon

import Combine
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
    

    
    
    
    
    public override var name: String {
        get {
            return cuckoo_manager.getter("name",
                superclassCall:
                    
                                    super.name
                    ,
                defaultCall:  __defaultImplStub!.name)
        }
        
    }
    
    
    
    
    
    public override var writer: EncodedStreamSignalWriter {
        get {
            return cuckoo_manager.getter("writer",
                superclassCall:
                    
                                    super.writer
                    ,
                defaultCall:  __defaultImplStub!.writer)
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
    receive(completion: Subscribers.Completion<Failure>)
    """,
            parameters: (completion),
            escapingParameters: (completion),
            superclassCall:
                
                super.receive(completion: completion)
                ,
            defaultCall: __defaultImplStub!.receive(completion: completion))
        
    }
    
    
    
    
    
    public override func nextPut(_ aSignal: Signal) throws {
        
    return try cuckoo_manager.callThrows(
    """
    nextPut(_: Signal) throws
    """,
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
        
        
        
        var name: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStreamLogger, String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        
        
        
        var writer: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStreamLogger, EncodedStreamSignalWriter> {
            return .init(manager: cuckoo_manager, name: "writer")
        }
        
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method:
    """
    receive(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ClassStubFunction<(Signal), Subscribers.Demand> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method:
    """
    receive(_: Signal) -> Subscribers.Demand
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Failure>)> where M1.MatchedType == Subscribers.Completion<Failure> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Failure>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method:
    """
    receive(completion: Subscribers.Completion<Failure>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Signal)> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStreamLogger.self, method:
    """
    nextPut(_: Signal) throws
    """, parameterMatchers: matchers))
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
    
        
        
        
        var name: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var writer: Cuckoo.VerifyReadOnlyProperty<EncodedStreamSignalWriter> {
            return .init(manager: cuckoo_manager, name: "writer", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(Subscribers.Completion<Failure>), Void> where M1.MatchedType == Subscribers.Completion<Failure> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Failure>)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(completion: Subscribers.Completion<Failure>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return cuckoo_manager.verify(
    """
    nextPut(_: Signal) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class StreamLoggerStub: StreamLogger {
    
    
    
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public override var writer: EncodedStreamSignalWriter {
        get {
            return DefaultValueRegistry.defaultValue(for: (EncodedStreamSignalWriter).self)
        }
        
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
    
    
    
    
    
    public override func nextPut(_ aSignal: Signal) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




