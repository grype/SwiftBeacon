import Cuckoo
@testable import Beacon

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
    

    
    
    
    public override var url: URL! {
        get {
            return cuckoo_manager.getter("url",
                superclassCall:
                    
                    super.url
                    ,
                defaultCall: __defaultImplStub!.url)
        }
        
    }
    
    
    
    public override var method: String! {
        get {
            return cuckoo_manager.getter("method",
                superclassCall:
                    
                    super.method
                    ,
                defaultCall: __defaultImplStub!.method)
        }
        
    }
    
    
    
    public override var encoder: SignalEncoder {
        get {
            return cuckoo_manager.getter("encoder",
                superclassCall:
                    
                    super.encoder
                    ,
                defaultCall: __defaultImplStub!.encoder)
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
    
    
    
    public override var urlSessionTask: URLSessionTask? {
        get {
            return cuckoo_manager.getter("urlSessionTask",
                superclassCall:
                    
                    super.urlSessionTask
                    ,
                defaultCall: __defaultImplStub!.urlSessionTask)
        }
        
        set {
            cuckoo_manager.setter("urlSessionTask",
                value: newValue,
                superclassCall:
                    
                    super.urlSessionTask = newValue
                    ,
                defaultCall: __defaultImplStub!.urlSessionTask = newValue)
        }
        
    }
    
    
    
    public override var lastCompletionDate: Date? {
        get {
            return cuckoo_manager.getter("lastCompletionDate",
                superclassCall:
                    
                    super.lastCompletionDate
                    ,
                defaultCall: __defaultImplStub!.lastCompletionDate)
        }
        
        set {
            cuckoo_manager.setter("lastCompletionDate",
                value: newValue,
                superclassCall:
                    
                    super.lastCompletionDate = newValue
                    ,
                defaultCall: __defaultImplStub!.lastCompletionDate = newValue)
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
    
    
    
    public override func createUrlRequest(with data: [Data]) -> URLRequest? {
        
    return cuckoo_manager.call("createUrlRequest(with: [Data]) -> URLRequest?",
            parameters: (data),
            escapingParameters: (data),
            superclassCall:
                
                super.createUrlRequest(with: data)
                ,
            defaultCall: __defaultImplStub!.createUrlRequest(with: data))
        
    }
    
    
    
    public override func perform(urlRequest: URLRequest, completion: ((Bool)->Void)?)  {
        
    return cuckoo_manager.call("perform(urlRequest: URLRequest, completion: ((Bool)->Void)?)",
            parameters: (urlRequest, completion),
            escapingParameters: (urlRequest, completion),
            superclassCall:
                
                super.perform(urlRequest: urlRequest, completion: completion)
                ,
            defaultCall: __defaultImplStub!.perform(urlRequest: urlRequest, completion: completion))
        
    }
    

	public struct __StubbingProxy_JRPCLogger: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
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
	    
	    
	    var urlSessionTask: Cuckoo.ClassToBeStubbedOptionalProperty<MockJRPCLogger, URLSessionTask> {
	        return .init(manager: cuckoo_manager, name: "urlSessionTask")
	    }
	    
	    
	    var lastCompletionDate: Cuckoo.ClassToBeStubbedOptionalProperty<MockJRPCLogger, Date> {
	        return .init(manager: cuckoo_manager, name: "lastCompletionDate")
	    }
	    
	    
	    var shouldFlush: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockJRPCLogger, Bool> {
	        return .init(manager: cuckoo_manager, name: "shouldFlush")
	    }
	    
	    
	    func encodeSignal<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubFunction<(Signal), Data?> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method: "encodeSignal(_: Signal) -> Data?", parameterMatchers: matchers))
	    }
	    
	    func flush() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method: "flush()", parameterMatchers: matchers))
	    }
	    
	    func createUrlRequest<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.ClassStubFunction<([Data]), URLRequest?> where M1.MatchedType == [Data] {
	        let matchers: [Cuckoo.ParameterMatcher<([Data])>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method: "createUrlRequest(with: [Data]) -> URLRequest?", parameterMatchers: matchers))
	    }
	    
	    func perform<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(urlRequest: M1, completion: M2) -> Cuckoo.ClassStubNoReturnFunction<(URLRequest, ((Bool)->Void)?)> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == ((Bool)->Void) {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest, ((Bool)->Void)?)>] = [wrap(matchable: urlRequest) { $0.0 }, wrap(matchable: completion) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockJRPCLogger.self, method: "perform(urlRequest: URLRequest, completion: ((Bool)->Void)?)", parameterMatchers: matchers))
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
	
	    
	    
	    var url: Cuckoo.VerifyReadOnlyProperty<URL?> {
	        return .init(manager: cuckoo_manager, name: "url", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var method: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "method", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var encoder: Cuckoo.VerifyProperty<SignalEncoder> {
	        return .init(manager: cuckoo_manager, name: "encoder", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var urlSessionTask: Cuckoo.VerifyOptionalProperty<URLSessionTask> {
	        return .init(manager: cuckoo_manager, name: "urlSessionTask", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var lastCompletionDate: Cuckoo.VerifyOptionalProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "lastCompletionDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var shouldFlush: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "shouldFlush", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    func createUrlRequest<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.__DoNotUse<([Data]), URLRequest?> where M1.MatchedType == [Data] {
	        let matchers: [Cuckoo.ParameterMatcher<([Data])>] = [wrap(matchable: data) { $0 }]
	        return cuckoo_manager.verify("createUrlRequest(with: [Data]) -> URLRequest?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func perform<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(urlRequest: M1, completion: M2) -> Cuckoo.__DoNotUse<(URLRequest, ((Bool)->Void)?), Void> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == ((Bool)->Void) {
	        let matchers: [Cuckoo.ParameterMatcher<(URLRequest, ((Bool)->Void)?)>] = [wrap(matchable: urlRequest) { $0.0 }, wrap(matchable: completion) { $0.1 }]
	        return cuckoo_manager.verify("perform(urlRequest: URLRequest, completion: ((Bool)->Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class JRPCLoggerStub: JRPCLogger {
    
    
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
    
    
    public override var urlSessionTask: URLSessionTask? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLSessionTask?).self)
        }
        
        set { }
        
    }
    
    
    public override var lastCompletionDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    
    public override var shouldFlush: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
    public override func encodeSignal(_ aSignal: Signal) -> Data?  {
        return DefaultValueRegistry.defaultValue(for: (Data?).self)
    }
    
    public override func flush()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func createUrlRequest(with data: [Data]) -> URLRequest?  {
        return DefaultValueRegistry.defaultValue(for: (URLRequest?).self)
    }
    
    public override func perform(urlRequest: URLRequest, completion: ((Bool)->Void)?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

