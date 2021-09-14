import Cuckoo
@testable import Beacon

import Foundation


public class MockEncodedStreamSignalWriter: EncodedStreamSignalWriter, Cuckoo.ClassMock {
    
    public typealias MocksType = EncodedStreamSignalWriter
    
    public typealias Stubbing = __StubbingProxy_EncodedStreamSignalWriter
    public typealias Verification = __VerificationProxy_EncodedStreamSignalWriter

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: EncodedStreamSignalWriter?

    public func enableDefaultImplementation(_ stub: EncodedStreamSignalWriter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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
    
    
    
    public override var stream: OutputStream {
        get {
            return cuckoo_manager.getter("stream",
                superclassCall:
                    
                    super.stream
                    ,
                defaultCall: __defaultImplStub!.stream)
        }
        
        set {
            cuckoo_manager.setter("stream",
                value: newValue,
                superclassCall:
                    
                    super.stream = newValue
                    ,
                defaultCall: __defaultImplStub!.stream = newValue)
        }
        
    }
    
    
    
    public override var separator: Data {
        get {
            return cuckoo_manager.getter("separator",
                superclassCall:
                    
                    super.separator
                    ,
                defaultCall: __defaultImplStub!.separator)
        }
        
        set {
            cuckoo_manager.setter("separator",
                value: newValue,
                superclassCall:
                    
                    super.separator = newValue
                    ,
                defaultCall: __defaultImplStub!.separator = newValue)
        }
        
    }
    

    

    
    
    
    public override func open()  {
        
    return cuckoo_manager.call("open()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.open()
                ,
            defaultCall: __defaultImplStub!.open())
        
    }
    
    
    
    public override func close()  {
        
    return cuckoo_manager.call("close()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.close()
                ,
            defaultCall: __defaultImplStub!.close())
        
    }
    
    
    
    public override func write(_ aSignal: Signal) throws {
        
    return try cuckoo_manager.callThrows("write(_: Signal) throws",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.write(aSignal)
                ,
            defaultCall: __defaultImplStub!.write(aSignal))
        
    }
    

	public struct __StubbingProxy_EncodedStreamSignalWriter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var encoder: Cuckoo.ClassToBeStubbedProperty<MockEncodedStreamSignalWriter, SignalEncoder> {
	        return .init(manager: cuckoo_manager, name: "encoder")
	    }
	    
	    
	    var stream: Cuckoo.ClassToBeStubbedProperty<MockEncodedStreamSignalWriter, OutputStream> {
	        return .init(manager: cuckoo_manager, name: "stream")
	    }
	    
	    
	    var separator: Cuckoo.ClassToBeStubbedProperty<MockEncodedStreamSignalWriter, Data> {
	        return .init(manager: cuckoo_manager, name: "separator")
	    }
	    
	    
	    func open() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEncodedStreamSignalWriter.self, method: "open()", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEncodedStreamSignalWriter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func write<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Signal)> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEncodedStreamSignalWriter.self, method: "write(_: Signal) throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_EncodedStreamSignalWriter: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var encoder: Cuckoo.VerifyProperty<SignalEncoder> {
	        return .init(manager: cuckoo_manager, name: "encoder", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var stream: Cuckoo.VerifyProperty<OutputStream> {
	        return .init(manager: cuckoo_manager, name: "stream", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var separator: Cuckoo.VerifyProperty<Data> {
	        return .init(manager: cuckoo_manager, name: "separator", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func open() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("open()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func close() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func write<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("write(_: Signal) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class EncodedStreamSignalWriterStub: EncodedStreamSignalWriter {
    
    
    public override var encoder: SignalEncoder {
        get {
            return DefaultValueRegistry.defaultValue(for: (SignalEncoder).self)
        }
        
        set { }
        
    }
    
    
    public override var stream: OutputStream {
        get {
            return DefaultValueRegistry.defaultValue(for: (OutputStream).self)
        }
        
        set { }
        
    }
    
    
    public override var separator: Data {
        get {
            return DefaultValueRegistry.defaultValue(for: (Data).self)
        }
        
        set { }
        
    }
    

    

    
    public override func open()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func close()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func write(_ aSignal: Signal) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

