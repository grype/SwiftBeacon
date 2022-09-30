import Cuckoo
@testable import Beacon

import Foundation






public class MockFileWheel: FileWheel, Cuckoo.ClassMock {
    
    public typealias MocksType = FileWheel
    
    public typealias Stubbing = __StubbingProxy_FileWheel
    public typealias Verification = __VerificationProxy_FileWheel

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: FileWheel?

    public func enableDefaultImplementation(_ stub: FileWheel) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var conditionBlock: ConditionBlock {
        get {
            return cuckoo_manager.getter("conditionBlock",
                superclassCall:
                    
                    super.conditionBlock
                    ,
                defaultCall: __defaultImplStub!.conditionBlock)
        }
        
        set {
            cuckoo_manager.setter("conditionBlock",
                value: newValue,
                superclassCall:
                    
                    super.conditionBlock = newValue
                    ,
                defaultCall: __defaultImplStub!.conditionBlock = newValue)
        }
        
    }
    
    
    
    
    
    public override var rotationBlock: RotationBlock {
        get {
            return cuckoo_manager.getter("rotationBlock",
                superclassCall:
                    
                    super.rotationBlock
                    ,
                defaultCall: __defaultImplStub!.rotationBlock)
        }
        
        set {
            cuckoo_manager.setter("rotationBlock",
                value: newValue,
                superclassCall:
                    
                    super.rotationBlock = newValue
                    ,
                defaultCall: __defaultImplStub!.rotationBlock = newValue)
        }
        
    }
    
    

    

    
    
    
    
    public override func shouldRotate(fileAt url: URL) -> Bool {
        
    return cuckoo_manager.call(
    """
    shouldRotate(fileAt: URL) -> Bool
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.shouldRotate(fileAt: url)
                ,
            defaultCall: __defaultImplStub!.shouldRotate(fileAt: url))
        
    }
    
    
    
    
    
    public override func rotate(fileAt url: URL) throws {
        
    return try cuckoo_manager.callThrows(
    """
    rotate(fileAt: URL) throws
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.rotate(fileAt: url)
                ,
            defaultCall: __defaultImplStub!.rotate(fileAt: url))
        
    }
    
    
    
    
    
    public override func rotateIfNeeded(fileAt url: URL) throws {
        
    return try cuckoo_manager.callThrows(
    """
    rotateIfNeeded(fileAt: URL) throws
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.rotateIfNeeded(fileAt: url)
                ,
            defaultCall: __defaultImplStub!.rotateIfNeeded(fileAt: url))
        
    }
    
    

    public struct __StubbingProxy_FileWheel: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var conditionBlock: Cuckoo.ClassToBeStubbedProperty<MockFileWheel, ConditionBlock> {
            return .init(manager: cuckoo_manager, name: "conditionBlock")
        }
        
        
        
        
        var rotationBlock: Cuckoo.ClassToBeStubbedProperty<MockFileWheel, RotationBlock> {
            return .init(manager: cuckoo_manager, name: "rotationBlock")
        }
        
        
        
        
        
        func shouldRotate<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.ClassStubFunction<(URL), Bool> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileWheel.self, method:
    """
    shouldRotate(fileAt: URL) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rotate<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileWheel.self, method:
    """
    rotate(fileAt: URL) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rotateIfNeeded<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileWheel.self, method:
    """
    rotateIfNeeded(fileAt: URL) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FileWheel: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var conditionBlock: Cuckoo.VerifyProperty<ConditionBlock> {
            return .init(manager: cuckoo_manager, name: "conditionBlock", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var rotationBlock: Cuckoo.VerifyProperty<RotationBlock> {
            return .init(manager: cuckoo_manager, name: "rotationBlock", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func shouldRotate<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.__DoNotUse<(URL), Bool> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    shouldRotate(fileAt: URL) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func rotate<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    rotate(fileAt: URL) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func rotateIfNeeded<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    rotateIfNeeded(fileAt: URL) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FileWheelStub: FileWheel {
    
    
    
    
    public override var conditionBlock: ConditionBlock {
        get {
            return DefaultValueRegistry.defaultValue(for: (ConditionBlock).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var rotationBlock: RotationBlock {
        get {
            return DefaultValueRegistry.defaultValue(for: (RotationBlock).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func shouldRotate(fileAt url: URL) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public override func rotate(fileAt url: URL) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func rotateIfNeeded(fileAt url: URL) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}




