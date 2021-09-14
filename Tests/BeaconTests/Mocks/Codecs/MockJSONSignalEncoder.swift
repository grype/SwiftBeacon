import Cuckoo
@testable import Beacon

import Foundation



public class MockJSONSignalEncoder: JSONSignalEncoder, Cuckoo.ClassMock {
    
    public typealias MocksType = JSONSignalEncoder
    
    public typealias Stubbing = __StubbingProxy_JSONSignalEncoder
    public typealias Verification = __VerificationProxy_JSONSignalEncoder

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: JSONSignalEncoder?

    public func enableDefaultImplementation(_ stub: JSONSignalEncoder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var encoder: JSONEncoder {
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
    

    

    
    
    
    public override func encode(_ aSignal: Signal) throws -> Data {
        
    return try cuckoo_manager.callThrows("encode(_: Signal) throws -> Data",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.encode(aSignal)
                ,
            defaultCall: __defaultImplStub!.encode(aSignal))
        
    }
    

	public struct __StubbingProxy_JSONSignalEncoder: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var encoder: Cuckoo.ClassToBeStubbedProperty<MockJSONSignalEncoder, JSONEncoder> {
	        return .init(manager: cuckoo_manager, name: "encoder")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubThrowingFunction<(Signal), Data> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockJSONSignalEncoder.self, method: "encode(_: Signal) throws -> Data", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_JSONSignalEncoder: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var encoder: Cuckoo.VerifyProperty<JSONEncoder> {
	        return .init(manager: cuckoo_manager, name: "encoder", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Data> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("encode(_: Signal) throws -> Data", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class JSONSignalEncoderStub: JSONSignalEncoder {
    
    
    public override var encoder: JSONEncoder {
        get {
            return DefaultValueRegistry.defaultValue(for: (JSONEncoder).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(_ aSignal: Signal) throws -> Data  {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
}

