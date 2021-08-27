import Cuckoo
@testable import Beacon

import Foundation


@available(*, message: "mocked")

public class MockMachImageImportsSignal: MachImageImportsSignal, Cuckoo.ClassMock {
    
    public typealias MocksType = MachImageImportsSignal
    
    public typealias Stubbing = __StubbingProxy_MachImageImportsSignal
    public typealias Verification = __VerificationProxy_MachImageImportsSignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: MachImageImportsSignal?

    public func enableDefaultImplementation(_ stub: MachImageImportsSignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var added: [MachImage]? {
        get {
            return cuckoo_manager.getter("added",
                superclassCall:
                    
                    super.added
                    ,
                defaultCall: __defaultImplStub!.added)
        }
        
        set {
            cuckoo_manager.setter("added",
                value: newValue,
                superclassCall:
                    
                    super.added = newValue
                    ,
                defaultCall: __defaultImplStub!.added = newValue)
        }
        
    }
    
    
    
    public override var removed: [MachImage]? {
        get {
            return cuckoo_manager.getter("removed",
                superclassCall:
                    
                    super.removed
                    ,
                defaultCall: __defaultImplStub!.removed)
        }
        
        set {
            cuckoo_manager.setter("removed",
                value: newValue,
                superclassCall:
                    
                    super.removed = newValue
                    ,
                defaultCall: __defaultImplStub!.removed = newValue)
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
    

	public struct __StubbingProxy_MachImageImportsSignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var added: Cuckoo.ClassToBeStubbedOptionalProperty<MockMachImageImportsSignal, [MachImage]> {
	        return .init(manager: cuckoo_manager, name: "added")
	    }
	    
	    
	    var removed: Cuckoo.ClassToBeStubbedOptionalProperty<MockMachImageImportsSignal, [MachImage]> {
	        return .init(manager: cuckoo_manager, name: "removed")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockMachImageImportsSignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var valueDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockMachImageImportsSignal, String?> {
	        return .init(manager: cuckoo_manager, name: "valueDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMachImageImportsSignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MachImageImportsSignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var added: Cuckoo.VerifyOptionalProperty<[MachImage]> {
	        return .init(manager: cuckoo_manager, name: "added", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var removed: Cuckoo.VerifyOptionalProperty<[MachImage]> {
	        return .init(manager: cuckoo_manager, name: "removed", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

public class MachImageImportsSignalStub: MachImageImportsSignal {
    
    
    public override var added: [MachImage]? {
        get {
            return DefaultValueRegistry.defaultValue(for: ([MachImage]?).self)
        }
        
        set { }
        
    }
    
    
    public override var removed: [MachImage]? {
        get {
            return DefaultValueRegistry.defaultValue(for: ([MachImage]?).self)
        }
        
        set { }
        
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

