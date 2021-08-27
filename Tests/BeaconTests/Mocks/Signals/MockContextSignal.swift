import Cuckoo
@testable import Beacon

import Foundation
import MachO


@available(*, message: "mocked")

public class MockContextSignal: ContextSignal, Cuckoo.ClassMock {
    
    public typealias MocksType = ContextSignal
    
    public typealias Stubbing = __StubbingProxy_ContextSignal
    public typealias Verification = __VerificationProxy_ContextSignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: ContextSignal?

    public func enableDefaultImplementation(_ stub: ContextSignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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
    
    
    
    public override var symbols: [String : [Int]] {
        get {
            return cuckoo_manager.getter("symbols",
                superclassCall:
                    
                    super.symbols
                    ,
                defaultCall: __defaultImplStub!.symbols)
        }
        
        set {
            cuckoo_manager.setter("symbols",
                value: newValue,
                superclassCall:
                    
                    super.symbols = newValue
                    ,
                defaultCall: __defaultImplStub!.symbols = newValue)
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
    

	public struct __StubbingProxy_ContextSignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var stack: Cuckoo.ClassToBeStubbedProperty<MockContextSignal, [String]> {
	        return .init(manager: cuckoo_manager, name: "stack")
	    }
	    
	    
	    var symbols: Cuckoo.ClassToBeStubbedProperty<MockContextSignal, [String : [Int]]> {
	        return .init(manager: cuckoo_manager, name: "symbols")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockContextSignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var debugDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockContextSignal, String> {
	        return .init(manager: cuckoo_manager, name: "debugDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockContextSignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_ContextSignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var stack: Cuckoo.VerifyProperty<[String]> {
	        return .init(manager: cuckoo_manager, name: "stack", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var symbols: Cuckoo.VerifyProperty<[String : [Int]]> {
	        return .init(manager: cuckoo_manager, name: "symbols", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var signalName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "signalName", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

public class ContextSignalStub: ContextSignal {
    
    
    public override var stack: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
        
        set { }
        
    }
    
    
    public override var symbols: [String : [Int]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String : [Int]]).self)
        }
        
        set { }
        
    }
    
    
    public override var signalName: String {
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

