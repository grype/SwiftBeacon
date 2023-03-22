import Cuckoo
@testable import Beacon

import Foundation
import SwiftAnnouncements






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
    

    

    

    
    
    
    
    public override func signal(_ aSignal: Signal)  {
        
    return cuckoo_manager.call(
    """
    signal(_: Signal)
    """,
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.signal(aSignal)
                ,
            defaultCall: __defaultImplStub!.signal(aSignal))
        
    }
    
    
    
    
    
    public override func when<T: Announceable>(_ aType: T.Type, subscriber: AnyObject?, do aBlock: @escaping (T, Announcer) -> Void)  {
        
    return cuckoo_manager.call(
    """
    when(_: T.Type, subscriber: AnyObject?, do: @escaping (T, Announcer) -> Void)
    """,
            parameters: (aType, subscriber, aBlock),
            escapingParameters: (aType, subscriber, aBlock),
            superclassCall:
                
                super.when(aType, subscriber: subscriber, do: aBlock)
                ,
            defaultCall: __defaultImplStub!.when(aType, subscriber: subscriber, do: aBlock))
        
    }
    
    
    
    
    
    public override func remove<T: Announceable>(subscription: Subscription<T>)  {
        
    return cuckoo_manager.call(
    """
    remove(subscription: Subscription<T>)
    """,
            parameters: (subscription),
            escapingParameters: (subscription),
            superclassCall:
                
                super.remove(subscription: subscription)
                ,
            defaultCall: __defaultImplStub!.remove(subscription: subscription))
        
    }
    
    
    
    
    
    public override func unsubscribe(_ anObject: AnyObject)  {
        
    return cuckoo_manager.call(
    """
    unsubscribe(_: AnyObject)
    """,
            parameters: (anObject),
            escapingParameters: (anObject),
            superclassCall:
                
                super.unsubscribe(anObject)
                ,
            defaultCall: __defaultImplStub!.unsubscribe(anObject))
        
    }
    
    

    public struct __StubbingProxy_Beacon: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func signal<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    signal(_: Signal)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func when<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, T: Announceable>(_ aType: M1, subscriber: M2, do aBlock: M3) -> Cuckoo.ClassStubNoReturnFunction<(T.Type, AnyObject?, (T, Announcer) -> Void)> where M1.MatchedType == T.Type, M2.OptionalMatchedType == AnyObject, M3.MatchedType == (T, Announcer) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(T.Type, AnyObject?, (T, Announcer) -> Void)>] = [wrap(matchable: aType) { $0.0 }, wrap(matchable: subscriber) { $0.1 }, wrap(matchable: aBlock) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    when(_: T.Type, subscriber: AnyObject?, do: @escaping (T, Announcer) -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func remove<M1: Cuckoo.Matchable, T: Announceable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription<T>)> where M1.MatchedType == Subscription<T> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription<T>)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    remove(subscription: Subscription<T>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func unsubscribe<M1: Cuckoo.Matchable>(_ anObject: M1) -> Cuckoo.ClassStubNoReturnFunction<(AnyObject)> where M1.MatchedType == AnyObject {
            let matchers: [Cuckoo.ParameterMatcher<(AnyObject)>] = [wrap(matchable: anObject) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBeacon.self, method:
    """
    unsubscribe(_: AnyObject)
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
        func signal<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return cuckoo_manager.verify(
    """
    signal(_: Signal)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func when<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, T: Announceable>(_ aType: M1, subscriber: M2, do aBlock: M3) -> Cuckoo.__DoNotUse<(T.Type, AnyObject?, (T, Announcer) -> Void), Void> where M1.MatchedType == T.Type, M2.OptionalMatchedType == AnyObject, M3.MatchedType == (T, Announcer) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(T.Type, AnyObject?, (T, Announcer) -> Void)>] = [wrap(matchable: aType) { $0.0 }, wrap(matchable: subscriber) { $0.1 }, wrap(matchable: aBlock) { $0.2 }]
            return cuckoo_manager.verify(
    """
    when(_: T.Type, subscriber: AnyObject?, do: @escaping (T, Announcer) -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func remove<M1: Cuckoo.Matchable, T: Announceable>(subscription: M1) -> Cuckoo.__DoNotUse<(Subscription<T>), Void> where M1.MatchedType == Subscription<T> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription<T>)>] = [wrap(matchable: subscription) { $0 }]
            return cuckoo_manager.verify(
    """
    remove(subscription: Subscription<T>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func unsubscribe<M1: Cuckoo.Matchable>(_ anObject: M1) -> Cuckoo.__DoNotUse<(AnyObject), Void> where M1.MatchedType == AnyObject {
            let matchers: [Cuckoo.ParameterMatcher<(AnyObject)>] = [wrap(matchable: anObject) { $0 }]
            return cuckoo_manager.verify(
    """
    unsubscribe(_: AnyObject)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class BeaconStub: Beacon {
    

    

    
    
    
    
    public override func signal(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func when<T: Announceable>(_ aType: T.Type, subscriber: AnyObject?, do aBlock: @escaping (T, Announcer) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func remove<T: Announceable>(subscription: Subscription<T>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func unsubscribe(_ anObject: AnyObject)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




