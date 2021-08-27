import Cuckoo
@testable import Beacon

import Foundation


@available(*, message: "mocked")

public class MockWrapperSignal: WrapperSignal, Cuckoo.ClassMock {
    
    public typealias MocksType = WrapperSignal
    
    public typealias Stubbing = __StubbingProxy_WrapperSignal
    public typealias Verification = __VerificationProxy_WrapperSignal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: WrapperSignal?

    public func enableDefaultImplementation(_ stub: WrapperSignal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var value: Any {
        get {
            return cuckoo_manager.getter("value",
                superclassCall:
                    
                    super.value
                    ,
                defaultCall: __defaultImplStub!.value)
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
    
    
    
    public override var userInfoDescription: String? {
        get {
            return cuckoo_manager.getter("userInfoDescription",
                superclassCall:
                    
                    super.userInfoDescription
                    ,
                defaultCall: __defaultImplStub!.userInfoDescription)
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
    
    
    
    public override func valueDescription(for aValue: Any) -> String {
        
    return cuckoo_manager.call("valueDescription(for: Any) -> String",
            parameters: (aValue),
            escapingParameters: (aValue),
            superclassCall:
                
                super.valueDescription(for: aValue)
                ,
            defaultCall: __defaultImplStub!.valueDescription(for: aValue))
        
    }
    
    
    
    public override func userInfoDescription(for aUserInfo: [AnyHashable : Any]) -> String {
        
    return cuckoo_manager.call("userInfoDescription(for: [AnyHashable : Any]) -> String",
            parameters: (aUserInfo),
            escapingParameters: (aUserInfo),
            superclassCall:
                
                super.userInfoDescription(for: aUserInfo)
                ,
            defaultCall: __defaultImplStub!.userInfoDescription(for: aUserInfo))
        
    }
    

	public struct __StubbingProxy_WrapperSignal: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var value: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockWrapperSignal, Any> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    
	    var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockWrapperSignal, String> {
	        return .init(manager: cuckoo_manager, name: "signalName")
	    }
	    
	    
	    var debugDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockWrapperSignal, String> {
	        return .init(manager: cuckoo_manager, name: "debugDescription")
	    }
	    
	    
	    var userInfoDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockWrapperSignal, String?> {
	        return .init(manager: cuckoo_manager, name: "userInfoDescription")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWrapperSignal.self, method: "encode(to: Encoder) throws", parameterMatchers: matchers))
	    }
	    
	    func valueDescription<M1: Cuckoo.Matchable>(for aValue: M1) -> Cuckoo.ClassStubFunction<(Any), String> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: aValue) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWrapperSignal.self, method: "valueDescription(for: Any) -> String", parameterMatchers: matchers))
	    }
	    
	    func userInfoDescription<M1: Cuckoo.Matchable>(for aUserInfo: M1) -> Cuckoo.ClassStubFunction<([AnyHashable : Any]), String> where M1.MatchedType == [AnyHashable : Any] {
	        let matchers: [Cuckoo.ParameterMatcher<([AnyHashable : Any])>] = [wrap(matchable: aUserInfo) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWrapperSignal.self, method: "userInfoDescription(for: [AnyHashable : Any]) -> String", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_WrapperSignal: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var value: Cuckoo.VerifyReadOnlyProperty<Any> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var signalName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "signalName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var debugDescription: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "debugDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var userInfoDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "userInfoDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<(Encoder), Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func valueDescription<M1: Cuckoo.Matchable>(for aValue: M1) -> Cuckoo.__DoNotUse<(Any), String> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: aValue) { $0 }]
	        return cuckoo_manager.verify("valueDescription(for: Any) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func userInfoDescription<M1: Cuckoo.Matchable>(for aUserInfo: M1) -> Cuckoo.__DoNotUse<([AnyHashable : Any]), String> where M1.MatchedType == [AnyHashable : Any] {
	        let matchers: [Cuckoo.ParameterMatcher<([AnyHashable : Any])>] = [wrap(matchable: aUserInfo) { $0 }]
	        return cuckoo_manager.verify("userInfoDescription(for: [AnyHashable : Any]) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class WrapperSignalStub: WrapperSignal {
    
    
    public override var value: Any {
        get {
            return DefaultValueRegistry.defaultValue(for: (Any).self)
        }
        
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
    
    
    public override var userInfoDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    

    

    
    public override func encode(to encoder: Encoder) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func valueDescription(for aValue: Any) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    public override func userInfoDescription(for aUserInfo: [AnyHashable : Any]) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
}

