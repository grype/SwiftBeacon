import Cuckoo
@testable import Beacon

import Foundation






public class MockSignalDescriptionEncoder: SignalDescriptionEncoder, Cuckoo.ClassMock {
    
    public typealias MocksType = SignalDescriptionEncoder
    
    public typealias Stubbing = __StubbingProxy_SignalDescriptionEncoder
    public typealias Verification = __VerificationProxy_SignalDescriptionEncoder

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: SignalDescriptionEncoder?

    public func enableDefaultImplementation(_ stub: SignalDescriptionEncoder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var encoding: String.Encoding {
        get {
            return cuckoo_manager.getter("encoding",
                superclassCall:
                    
                    super.encoding
                    ,
                defaultCall: __defaultImplStub!.encoding)
        }
        
        set {
            cuckoo_manager.setter("encoding",
                value: newValue,
                superclassCall:
                    
                    super.encoding = newValue
                    ,
                defaultCall: __defaultImplStub!.encoding = newValue)
        }
        
    }
    
    

    

    
    
    
    
    public override func encode(_ aSignal: Signal) throws -> Data {
        
    return try cuckoo_manager.callThrows(
    """
    encode(_: Signal) throws -> Data
    """,
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.encode(aSignal)
                ,
            defaultCall: __defaultImplStub!.encode(aSignal))
        
    }
    
    

    public struct __StubbingProxy_SignalDescriptionEncoder: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var encoding: Cuckoo.ClassToBeStubbedProperty<MockSignalDescriptionEncoder, String.Encoding> {
            return .init(manager: cuckoo_manager, name: "encoding")
        }
        
        
        
        
        
        func encode<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubThrowingFunction<(Signal), Data> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSignalDescriptionEncoder.self, method:
    """
    encode(_: Signal) throws -> Data
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SignalDescriptionEncoder: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var encoding: Cuckoo.VerifyProperty<String.Encoding> {
            return .init(manager: cuckoo_manager, name: "encoding", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func encode<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Data> where M1.MatchedType == Signal {
            let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
            return cuckoo_manager.verify(
    """
    encode(_: Signal) throws -> Data
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SignalDescriptionEncoderStub: SignalDescriptionEncoder {
    
    
    
    
    public override var encoding: String.Encoding {
        get {
            return DefaultValueRegistry.defaultValue(for: (String.Encoding).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func encode(_ aSignal: Signal) throws -> Data  {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
    
}




