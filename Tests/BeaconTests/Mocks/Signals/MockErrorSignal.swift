import Cuckoo
@testable import Beacon

import AnyCodable
import Foundation



public class MockErrorSignal: ErrorSignal, Cuckoo.ClassMock {
    
    public typealias MocksType = ErrorSignal
    
    public typealias Stubbing = __StubbingProxy_ErrorSignal
    public typealias Verification = __VerificationProxy_ErrorSignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ErrorSignal?

    public func enableDefaultImplementation(_ stub: ErrorSignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var error: Error {
        get {
            return cuckoo_manager.getter("error",
                superclassCall:
                    
                    super.error
                    ,
                defaultCall: __defaultImplStub!.error)
        }
        
    }
    
    
    
    public override var stack: [String] {
        get {
            return cuckoo_manager.getter("stack",
                superclassCall:
                    
                    super.stack
                    ,
                defaultCall: __defaultImplStub!.stack)
        }
        
        set {
            cuckoo_manager.setter("stack",
                value: newValue,
                superclassCall:
                    
                    super.stack = newValue
                    ,
                defaultCall: __defaultImplStub!.stack = newValue)
        }
        
    }
    
    
    
    public override var signalName: String {
        get {
            return cuckoo_manager.getter("signalName",
                superclassCall:
                    
                    super.signalName
                    ,
                defaultCall: __defaultImplStub!.signalName)
        }
        
    }
    
    
    
    public override var errorDescription: String {
        get {
            return cuckoo_manager.getter("errorDescription",
                superclassCall:
                    
                    super.errorDescription
                    ,
                defaultCall: __defaultImplStub!.errorDescription)
        }
        
    }
    
    
    
    public override var description: String {
        get {
            return cuckoo_manager.getter("description",
                superclassCall:
                    
                    super.description
                    ,
                defaultCall: __defaultImplStub!.description)
        }
        
    }
    
    
    
    public override var debugDescription: String {
        get {
            return cuckoo_manager.getter("debugDescription",
                superclassCall:
                    
                    super.debugDescription
                    ,
                defaultCall: __defaultImplStub!.debugDescription)
        }
        
    }
    

    

    
    
    
    public override func encode(to encoder: Encoder) throws {
        
    return try cuckoo_manager.callThrows("encode(to: Encoder) throws",
            parameters: (encoder),
            escapingParameters: (encoder),
            superclassCall:
                
                super.encode(to: encoder)
                ,
            defaultCall: __defaultImplStub!.encode(to: encoder))
        
    }
    

	public struct __StubbingProxy_ErrorSignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var error: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockErrorSignal, Error> {
	        return .init(manager: cuckoo_manager, name: "error")
	    }
	    
	    
	    var stack: Cuckoo.ClassToBeStubbedProperty<MockErrorSignal, [String]> {
	        return .init(manager: cuckoo_manager, name: "stack")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockErrorSignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var errorDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockErrorSignal, String> {
	        return .init(manager: cuckoo_manager, name: "errorDescription")
	    }
	    
	    
	    var description: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockErrorSignal, String> {
	        return .init(manager: cuckoo_manager, name: "description")
	    }
	    
	    
	    var debugDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockErrorSignal, String> {
	        return .init(manager: cuckoo_manager, name: "debugDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockErrorSignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_ErrorSignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var error: Cuckoo.VerifyReadOnlyProperty<Error> {
	        return .init(manager: cuckoo_manager, name: "error", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var stack: Cuckoo.VerifyProperty<[String]> {
	        return .init(manager: cuckoo_manager, name: "stack", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var signalName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "signalName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var errorDescription: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "errorDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var description: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "description", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var debugDescription: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "debugDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<(Encoder), Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class ErrorSignalStub: ErrorSignal {
    
    
    public override var error: Error {
        get {
            return DefaultValueRegistry.defaultValue(for: (Error).self)
        }
        
    }
    
    
    public override var stack: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
        
        set { }
        
    }
    
    
    public override var signalName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var errorDescription: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var description: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var debugDescription: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
    public override func encode(to encoder: Encoder) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

