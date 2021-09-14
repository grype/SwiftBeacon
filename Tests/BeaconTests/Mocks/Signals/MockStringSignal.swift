import Cuckoo
@testable import Beacon

import Foundation



public class MockStringSignal: StringSignal, Cuckoo.ClassMock {
    
    public typealias MocksType = StringSignal
    
    public typealias Stubbing = __StubbingProxy_StringSignal
    public typealias Verification = __VerificationProxy_StringSignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: StringSignal?

    public func enableDefaultImplementation(_ stub: StringSignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var message: String {
        get {
            return cuckoo_manager.getter("message",
                superclassCall:
                    
                    super.message
                    ,
                defaultCall: __defaultImplStub!.message)
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
    
    
    
    public override var valueDescription: String? {
        get {
            return cuckoo_manager.getter("valueDescription",
                superclassCall:
                    
                    super.valueDescription
                    ,
                defaultCall: __defaultImplStub!.valueDescription)
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
    

	public struct __StubbingProxy_StringSignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var message: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStringSignal, String> {
	        return .init(manager: cuckoo_manager, name: "message")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStringSignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var valueDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockStringSignal, String?> {
	        return .init(manager: cuckoo_manager, name: "valueDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStringSignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_StringSignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var message: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "message", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var signalName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "signalName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var valueDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "valueDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<(Encoder), Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class StringSignalStub: StringSignal {
    
    
    public override var message: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var signalName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var valueDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    

    

    
    public override func encode(to encoder: Encoder) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

