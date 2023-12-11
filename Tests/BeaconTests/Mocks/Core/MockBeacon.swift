import Cuckoo
@testable import Beacon

import Combine
import Foundation






public class MockBeacon: Beacon, Cuckoo.ClassMock {
    
    public typealias MocksType = Beacon
    
    public typealias Stubbing = __StubbingProxy_Beacon
    public typealias Verification = __VerificationProxy_Beacon

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Beacon?

    public func enableDefaultImplementation(_ stub: Beacon) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public override func send(_ value: Signal)  {
        
    return cuckoo_manager.call(
    """
    send(_: Signal)
    """,
            parameters: (value),
            escapingParameters: (value),
            superclassCall:
                
                super.send(value)
                ,
            defaultCall: __defaultImplStub!.send(value))
        
    }
    
    
    
    
    
    public override func send(completion: Subscribers.Completion<Never>)  {
        
    return cuckoo_manager.call(
    """
    send(completion: Subscribers.Completion<Never>)
    """,
            parameters: (completion),
            escapingParameters: (completion),
            superclassCall:
                
                super.send(completion: completion)
                ,
            defaultCall: __defaultImplStub!.send(completion: completion))
        
    }
    
    
    
    
    
    public override func send(subscription: Subscription)  {
        
    return cuckoo_manager.call(
    """
    send(subscription: Subscription)
    """,
            parameters: (subscription),
            escapingParameters: (subscription),
            superclassCall:
                
                super.send(subscription: subscription)
                ,
            defaultCall: __defaultImplStub!.send(subscription: subscription))
        
    }
    
    
    
    
    
    public override func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input {
        
    return cuckoo_manager.call(
    """
    receive(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input
    """,
            parameters: (subscriber),
            escapingParameters: (subscriber),
            superclassCall:
                
                super.receive(subscriber: subscriber)
                ,
            defaultCall: __defaultImplStub!.receive(subscriber: subscriber))
        
    }
    
    

    public struct __StubbingProxy_Beacon: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func send<M1: Cuckoo.Matchable>(_ value: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: value) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    send(_: Signal)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func send<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Never>)> where M1.MatchedType == Subscribers.Completion<Never> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Never>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    send(completion: Subscribers.Completion<Never>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func send<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    send(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable, S>(subscriber: M1) -> Cuckoo.ClassStubNoReturnFunction<(S)> where M1.MatchedType == S, S: Subscriber, Never == S.Failure, Signal == S.Input {
            let matchers: [Cuckoo.ParameterMatcher<(S)>] = [wrap(matchable: subscriber) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    receive(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_Beacon: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func send<M1: Cuckoo.Matchable>(_ value: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: value) { $0 }]
            return cuckoo_manager.verify(
    """
    send(_: Signal)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func send<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(Subscribers.Completion<Never>), Void> where M1.MatchedType == Subscribers.Completion<Never> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Never>)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    send(completion: Subscribers.Completion<Never>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func send<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.__DoNotUse<(Subscription), Void> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return cuckoo_manager.verify(
    """
    send(subscription: Subscription)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func receive<M1: Cuckoo.Matchable, S>(subscriber: M1) -> Cuckoo.__DoNotUse<(S), Void> where M1.MatchedType == S, S: Subscriber, Never == S.Failure, Signal == S.Input {
            let matchers: [Cuckoo.ParameterMatcher<(S)>] = [wrap(matchable: subscriber) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class BeaconStub: Beacon {
    

    

    
    
    
    
    public override func send(_ value: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func send(completion: Subscribers.Completion<Never>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func send(subscription: Subscription)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Signal == S.Input  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




