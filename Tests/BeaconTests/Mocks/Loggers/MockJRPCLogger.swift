import Cuckoo
@testable import Beacon

import Combine
import Foundation






public class MockJRPCLogger: JRPCLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = JRPCLogger
    
    public typealias Stubbing = __StubbingProxy_JRPCLogger
    public typealias Verification = __VerificationProxy_JRPCLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: JRPCLogger?

    public func enableDefaultImplementation(_ stub: JRPCLogger) {
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
    
    
    
    
    
    public override var url: URL! {
        get {
            return cuckoo_manager.getter("url",
                superclassCall:
                    
                                    super.url
                    ,
                defaultCall:  __defaultImplStub!.url)
        }
        
    }
    
    
    
    
    
    public override var method: String! {
        get {
            return cuckoo_manager.getter("method",
                superclassCall:
                    
                                    super.method
                    ,
                defaultCall:  __defaultImplStub!.method)
        }
        
    }
    
    
    
    
    
    public override var encoder: SignalEncoder {
        get {
            return cuckoo_manager.getter("encoder",
                superclassCall:
                    
                                    super.encoder
                    ,
                defaultCall:  __defaultImplStub!.encoder)
        }
        
        set {
            cuckoo_manager.setter("encoder",
                value: newValue,
                superclassCall:
                    
                    super.encoder = newValue
                    ,
                defaultCall: __defaultImplStub!.encoder = newValue)
        }
        
    }
    
    
    
    
    
    public override var urlSessionTasks: [URLSessionTask] {
        get {
            return cuckoo_manager.getter("urlSessionTasks",
                superclassCall:
                    
                                    super.urlSessionTasks
                    ,
                defaultCall:  __defaultImplStub!.urlSessionTasks)
        }
        
        set {
            cuckoo_manager.setter("urlSessionTasks",
                value: newValue,
                superclassCall:
                    
                    super.urlSessionTasks = newValue
                    ,
                defaultCall: __defaultImplStub!.urlSessionTasks = newValue)
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
    
    
    
    
    
    public override func receive(_ input: Input) -> Subscribers.Demand {
        
    return cuckoo_manager.call(
    """
    receive(_: Input) -> Subscribers.Demand
    """,
            parameters: (input),
            escapingParameters: (input),
            superclassCall:
                
                super.receive(input)
                ,
            defaultCall: __defaultImplStub!.receive(input))
        
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
    
    
    
    
    
    public override func createUrlRequest(with data: [Data]) -> URLRequest {
        
    return cuckoo_manager.call(
    """
    createUrlRequest(with: [Data]) -> URLRequest
    """,
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.createUrlRequest(with: data)
                ,
            defaultCall: __defaultImplStub!.createUrlRequest(with: data))
        
    }
    
    
    
    
    
    public override func perform(urlRequest: URLRequest)  {
        
    return cuckoo_manager.call(
    """
    perform(urlRequest: URLRequest)
    """,
            parameters: (urlRequest),
            escapingParameters: (urlRequest),
            superclassCall:
                
                super.perform(urlRequest: urlRequest)
                ,
            defaultCall: __defaultImplStub!.perform(urlRequest: urlRequest))
        
    }
    
    
    
    
    
    public override func cleanSessionTasks()  {
        
    return cuckoo_manager.call(
    """
    cleanSessionTasks()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.cleanSessionTasks()
                ,
            defaultCall: __defaultImplStub!.cleanSessionTasks())
        
    }
    
    

    public struct __StubbingProxy_JRPCLogger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var name: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockJRPCLogger, String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        
        
        
        var url: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockJRPCLogger, URL?> {
            return .init(manager: cuckoo_manager, name: "url")
        }
        
        
        
        
        var method: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockJRPCLogger, String?> {
            return .init(manager: cuckoo_manager, name: "method")
        }
        
        
        
        
        var encoder: Cuckoo.ClassToBeStubbedProperty<MockJRPCLogger, SignalEncoder> {
            return .init(manager: cuckoo_manager, name: "encoder")
        }
        
        
        
        
        var urlSessionTasks: Cuckoo.ClassToBeStubbedProperty<MockJRPCLogger, [URLSessionTask]> {
            return .init(manager: cuckoo_manager, name: "urlSessionTasks")
        }
        
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(subscription: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscription)> where M1.MatchedType == Subscription {
            let matchers: [Cuckoo.ParameterMatcher<(Subscription)>] = [wrap(matchable: subscription) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    receive(subscription: Subscription)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.ClassStubFunction<(Input), Subscribers.Demand> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    receive(_: Input) -> Subscribers.Demand
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func receive<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ClassStubNoReturnFunction<(Subscribers.Completion<Error>)> where M1.MatchedType == Subscribers.Completion<Error> {
            let matchers: [Cuckoo.ParameterMatcher<(Subscribers.Completion<Error>)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    receive(completion: Subscribers.Completion<Error>)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func createUrlRequest<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.ClassStubFunction<([Data]), URLRequest> where M1.MatchedType == [Data] {
            let matchers: [Cuckoo.ParameterMatcher<([Data])>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    createUrlRequest(with: [Data]) -> URLRequest
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func perform<M1: Cuckoo.Matchable>(urlRequest: M1) -> Cuckoo.ClassStubNoReturnFunction<(URLRequest)> where M1.MatchedType == URLRequest {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest)>] = [wrap(matchable: urlRequest) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    perform(urlRequest: URLRequest)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func cleanSessionTasks() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method:
    """
    cleanSessionTasks()
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_JRPCLogger: Cuckoo.VerificationProxy {
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
        
        
        
        
        var url: Cuckoo.VerifyReadOnlyProperty<URL?> {
            return .init(manager: cuckoo_manager, name: "url", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var method: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "method", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var encoder: Cuckoo.VerifyProperty<SignalEncoder> {
            return .init(manager: cuckoo_manager, name: "encoder", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var urlSessionTasks: Cuckoo.VerifyProperty<[URLSessionTask]> {
            return .init(manager: cuckoo_manager, name: "urlSessionTasks", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func receive<M1: Cuckoo.Matchable>(_ input: M1) -> Cuckoo.__DoNotUse<(Input), Subscribers.Demand> where M1.MatchedType == Input {
            let matchers: [Cuckoo.ParameterMatcher<(Input)>] = [wrap(matchable: input) { $0 }]
            return cuckoo_manager.verify(
    """
    receive(_: Input) -> Subscribers.Demand
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
        func createUrlRequest<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.__DoNotUse<([Data]), URLRequest> where M1.MatchedType == [Data] {
            let matchers: [Cuckoo.ParameterMatcher<([Data])>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify(
    """
    createUrlRequest(with: [Data]) -> URLRequest
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func perform<M1: Cuckoo.Matchable>(urlRequest: M1) -> Cuckoo.__DoNotUse<(URLRequest), Void> where M1.MatchedType == URLRequest {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest)>] = [wrap(matchable: urlRequest) { $0 }]
            return cuckoo_manager.verify(
    """
    perform(urlRequest: URLRequest)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func cleanSessionTasks() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    cleanSessionTasks()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class JRPCLoggerStub: JRPCLogger {
    
    
    
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public override var url: URL! {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL?).self)
        }
        
    }
    
    
    
    
    
    public override var method: String! {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    
    
    
    public override var encoder: SignalEncoder {
        get {
            return DefaultValueRegistry.defaultValue(for: (SignalEncoder).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var urlSessionTasks: [URLSessionTask] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([URLSessionTask]).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func receive(subscription: Subscription)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func receive(_ input: Input) -> Subscribers.Demand  {
        return DefaultValueRegistry.defaultValue(for: (Subscribers.Demand).self)
    }
    
    
    
    
    
    public override func receive(completion: Subscribers.Completion<Error>)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func createUrlRequest(with data: [Data]) -> URLRequest  {
        return DefaultValueRegistry.defaultValue(for: (URLRequest).self)
    }
    
    
    
    
    
    public override func perform(urlRequest: URLRequest)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func cleanSessionTasks()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




