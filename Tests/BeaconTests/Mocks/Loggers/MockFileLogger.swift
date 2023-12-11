import Cuckoo
@testable import Beacon

import Combine
import Foundation






public class MockFileLogger: FileLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = FileLogger
    
    public typealias Stubbing = __StubbingProxy_FileLogger
    public typealias Verification = __VerificationProxy_FileLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: FileLogger?

    public func enableDefaultImplementation(_ stub: FileLogger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var url: URL {
        get {
            return cuckoo_manager.getter("url",
                superclassCall:
                    
                                    super.url
                    ,
                defaultCall:  __defaultImplStub!.url)
        }
        
    }
    
    
    
    
    
    public override var rotateOnSubscription: Bool {
        get {
            return cuckoo_manager.getter("rotateOnStart",
                superclassCall:
                    
                                    super.rotateOnSubscription
                    ,
                defaultCall:  __defaultImplStub!.rotateOnSubscription)
        }
        
        set {
            cuckoo_manager.setter("rotateOnStart",
                value: newValue,
                superclassCall:
                    
                    super.rotateOnSubscription = newValue
                    ,
                defaultCall: __defaultImplStub!.rotateOnSubscription = newValue)
        }
        
    }
    
    
    
    
    
    public override var wheel: FileRotation? {
        get {
            return cuckoo_manager.getter("wheel",
                superclassCall:
                    
                                    super.wheel
                    ,
                defaultCall:  __defaultImplStub!.wheel)
        }
        
        set {
            cuckoo_manager.setter("wheel",
                value: newValue,
                superclassCall:
                    
                    super.wheel = newValue
                    ,
                defaultCall: __defaultImplStub!.wheel = newValue)
        }
        
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
    
    
    
    
    
    public override var writer: EncodedStreamSignalWriter! {
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
    
    
    
    
    
    public override func rotateFileIfNeeded()  {
        
    return cuckoo_manager.call(
    """
    rotateFileIfNeeded()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.rotateFileIfNeeded()
                ,
            defaultCall: __defaultImplStub!.rotateFileIfNeeded())
        
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Error>)  {
        
    return cuckoo_manager.call(
    """
    receive(completion: Subscribers.Completion<Error>)
    """,
            parameters: (completion),
            escapingParameters: (completion),
            superclassCall:
                
                super.receive(completion: completion)
                ,
            defaultCall: __defaultImplStub!.receive(completion: completion))
        
    }
    
    
    
    
    
    public override func forceRotate() throws {
        
    return try cuckoo_manager.callThrows(
    """
    forceRotate() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.forceRotate()
                ,
            defaultCall: __defaultImplStub!.forceRotate())
        
    }
    
    

    public struct __StubbingProxy_FileLogger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var url: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockFileLogger, URL> {
            return .init(manager: cuckoo_manager, name: "url")
        }
        
        
        
        
        var rotateOnStart: Cuckoo.ClassToBeStubbedProperty<MockFileLogger, Bool> {
            return .init(manager: cuckoo_manager, name: "rotateOnStart")
        }
        
        
        
        
        var wheel: Cuckoo.ClassToBeStubbedOptionalProperty<MockFileLogger, FileRotation> {
            return .init(manager: cuckoo_manager, name: "wheel")
        }
        
        
        
        
        var name: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockFileLogger, String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        
        
        
        var writer: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockFileLogger, EncodedStreamSignalWriter?> {
            return .init(manager: cuckoo_manager, name: "writer")
        }
        
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method:
    """
    receive(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ClassStubFunction<(Signal), Subscribers.Demand> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method:
    """
    receive(_: Signal) -> Subscribers.Demand
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rotateFileIfNeeded() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method:
    """
    rotateFileIfNeeded()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Error>)> where M1.MatchedType == Subscribers.Completion<Error> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Error>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method:
    """
    receive(completion: Subscribers.Completion<Error>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func forceRotate() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method:
    """
    forceRotate() throws
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FileLogger: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var url: Cuckoo.VerifyReadOnlyProperty<URL> {
            return .init(manager: cuckoo_manager, name: "url", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var rotateOnStart: Cuckoo.VerifyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "rotateOnStart", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var wheel: Cuckoo.VerifyOptionalProperty<FileRotation> {
            return .init(manager: cuckoo_manager, name: "wheel", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var name: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var writer: Cuckoo.VerifyReadOnlyProperty<EncodedStreamSignalWriter?> {
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
        func rotateFileIfNeeded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    rotateFileIfNeeded()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(Subscribers.Completion<Error>), Void> where M1.MatchedType == Subscribers.Completion<Error> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Error>)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(completion: Subscribers.Completion<Error>)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func forceRotate() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    forceRotate() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FileLoggerStub: FileLogger {
    
    
    
    
    public override var url: URL {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL).self)
        }
        
    }
    
    
    
    
    
    public override var rotateOnSubscription: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var wheel: FileRotation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (FileRotation?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public override var writer: EncodedStreamSignalWriter! {
        get {
            return DefaultValueRegistry.defaultValue(for: (EncodedStreamSignalWriter?).self)
        }
        
    }
    
    

    

    
    
    
    
    public override func receive(subscription: Subscription)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive(_ input: Signal) -> Subscribers.Demand  {
        return DefaultValueRegistry.defaultValue(for: (Subscribers.Demand).self)
    }
    
    
    
    
    
    public override func rotateFileIfNeeded()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Error>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func forceRotate() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




