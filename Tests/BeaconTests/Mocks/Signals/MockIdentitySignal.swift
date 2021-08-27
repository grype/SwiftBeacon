import Cuckoo
@testable import Beacon

import Foundation


@available(*, message: "mocked")

public class MockIdentitySignal: IdentitySignal, Cuckoo.ClassMock {
    
    public typealias MocksType = IdentitySignal
    
    public typealias Stubbing = __StubbingProxy_IdentitySignal
    public typealias Verification = __VerificationProxy_IdentitySignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: IdentitySignal?

    public func enableDefaultImplementation(_ stub: IdentitySignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var beaconVersion: String {
        get {
            return cuckoo_manager.getter("beaconVersion",
                superclassCall:
                    
                    super.beaconVersion
                    ,
                defaultCall: __defaultImplStub!.beaconVersion)
        }
        
    }
    
    
    
    public override var systemInfo: SystemInfo {
        get {
            return cuckoo_manager.getter("systemInfo",
                superclassCall:
                    
                    super.systemInfo
                    ,
                defaultCall: __defaultImplStub!.systemInfo)
        }
        
        set {
            cuckoo_manager.setter("systemInfo",
                value: newValue,
                superclassCall:
                    
                    super.systemInfo = newValue
                    ,
                defaultCall: __defaultImplStub!.systemInfo = newValue)
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
    

	public struct __StubbingProxy_IdentitySignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var beaconVersion: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockIdentitySignal, String> {
	        return .init(manager: cuckoo_manager, name: "beaconVersion")
	    }
	    
	    
	    var systemInfo: Cuckoo.ClassToBeStubbedProperty<MockIdentitySignal, SystemInfo> {
	        return .init(manager: cuckoo_manager, name: "systemInfo")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockIdentitySignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var valueDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockIdentitySignal, String?> {
	        return .init(manager: cuckoo_manager, name: "valueDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIdentitySignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_IdentitySignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var beaconVersion: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "beaconVersion", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var systemInfo: Cuckoo.VerifyProperty<SystemInfo> {
	        return .init(manager: cuckoo_manager, name: "systemInfo", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

public class IdentitySignalStub: IdentitySignal {
    
    
    public override var beaconVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    public override var systemInfo: SystemInfo {
        get {
            return DefaultValueRegistry.defaultValue(for: (SystemInfo).self)
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

