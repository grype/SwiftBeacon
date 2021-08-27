import Cuckoo
@testable import Beacon

import Foundation


@available(*, message: "mocked")

public class MockFileLogger: FileLogger, Cuckoo.ClassMock {
    
    public typealias MocksType = FileLogger
    
    public typealias Stubbing = __StubbingProxy_FileLogger
    public typealias Verification = __VerificationProxy_FileLogger

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: FileLogger?

    public func enableDefaultImplementation(_ stub: FileLogger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var url: URL {
        get {
            return cuckoo_manager.getter("url",
                superclassCall:
                    
                    super.url
                    ,
                defaultCall: __defaultImplStub!.url)
        }
        
    }
    
    
    
    public override var rotateOnStart: Bool {
        get {
            return cuckoo_manager.getter("rotateOnStart",
                superclassCall:
                    
                    super.rotateOnStart
                    ,
                defaultCall: __defaultImplStub!.rotateOnStart)
        }
        
        set {
            cuckoo_manager.setter("rotateOnStart",
                value: newValue,
                superclassCall:
                    
                    super.rotateOnStart = newValue
                    ,
                defaultCall: __defaultImplStub!.rotateOnStart = newValue)
        }
        
    }
    
    
    
    public override var wheel: FileRotation? {
        get {
            return cuckoo_manager.getter("wheel",
                superclassCall:
                    
                    super.wheel
                    ,
                defaultCall: __defaultImplStub!.wheel)
        }
        
        set {
            cuckoo_manager.setter("wheel",
                value: newValue,
                superclassCall:
                    
                    super.wheel = newValue
                    ,
                defaultCall: __defaultImplStub!.wheel = newValue)
        }
        
    }
    

    

    
    
    
    public override func didStart(on beacons: [Beacon])  {
        
    return cuckoo_manager.call("didStart(on: [Beacon])",
            parameters: (beacons),
            escapingParameters: (beacons),
            superclassCall:
                
                super.didStart(on: beacons)
                ,
            defaultCall: __defaultImplStub!.didStart(on: beacons))
        
    }
    
    
    
    public override func nextPut(_ aSignal: Signal)  {
        
    return cuckoo_manager.call("nextPut(_: Signal)",
            parameters: (aSignal),
            escapingParameters: (aSignal),
            superclassCall:
                
                super.nextPut(aSignal)
                ,
            defaultCall: __defaultImplStub!.nextPut(aSignal))
        
    }
    
    
    
    public override func forceRotate() throws {
        
    return try cuckoo_manager.callThrows("forceRotate() throws",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.forceRotate()
                ,
            defaultCall: __defaultImplStub!.forceRotate())
        
    }
    

	public struct __StubbingProxy_FileLogger: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var url: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockFileLogger, URL> {
	        return .init(manager: cuckoo_manager, name: "url")
	    }
	    
	    
	    var rotateOnStart: Cuckoo.ClassToBeStubbedProperty<MockFileLogger, Bool> {
	        return .init(manager: cuckoo_manager, name: "rotateOnStart")
	    }
	    
	    
	    var wheel: Cuckoo.ClassToBeStubbedOptionalProperty<MockFileLogger, FileRotation> {
	        return .init(manager: cuckoo_manager, name: "wheel")
	    }
	    
	    
	    func didStart<M1: Cuckoo.Matchable>(on beacons: M1) -> Cuckoo.ClassStubNoReturnFunction<([Beacon])> where M1.MatchedType == [Beacon] {
	        let matchers: [Cuckoo.ParameterMatcher<([Beacon])>] = [wrap(matchable: beacons) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method: "didStart(on: [Beacon])", parameterMatchers: matchers))
	    }
	    
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.ClassStubNoReturnFunction<(Signal)> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method: "nextPut(_: Signal)", parameterMatchers: matchers))
	    }
	    
	    func forceRotate() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockFileLogger.self, method: "forceRotate() throws", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_FileLogger: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var url: Cuckoo.VerifyReadOnlyProperty<URL> {
	        return .init(manager: cuckoo_manager, name: "url", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var rotateOnStart: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "rotateOnStart", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var wheel: Cuckoo.VerifyOptionalProperty<FileRotation> {
	        return .init(manager: cuckoo_manager, name: "wheel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func didStart<M1: Cuckoo.Matchable>(on beacons: M1) -> Cuckoo.__DoNotUse<([Beacon]), Void> where M1.MatchedType == [Beacon] {
	        let matchers: [Cuckoo.ParameterMatcher<([Beacon])>] = [wrap(matchable: beacons) { $0 }]
	        return cuckoo_manager.verify("didStart(on: [Beacon])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func nextPut<M1: Cuckoo.Matchable>(_ aSignal: M1) -> Cuckoo.__DoNotUse<(Signal), Void> where M1.MatchedType == Signal {
	        let matchers: [Cuckoo.ParameterMatcher<(Signal)>] = [wrap(matchable: aSignal) { $0 }]
	        return cuckoo_manager.verify("nextPut(_: Signal)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func forceRotate() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("forceRotate() throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class FileLoggerStub: FileLogger {
    
    
    public override var url: URL {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL).self)
        }
        
    }
    
    
    public override var rotateOnStart: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public override var wheel: FileRotation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (FileRotation?).self)
        }
        
        set { }
        
    }
    

    

    
    public override func didStart(on beacons: [Beacon])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func nextPut(_ aSignal: Signal)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func forceRotate() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

