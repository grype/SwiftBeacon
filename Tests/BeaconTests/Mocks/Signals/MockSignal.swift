import Cuckoo
@testable import Beacon

import AnyCodable
import Foundation






public class MockSignal: Signal, Cuckoo.ClassMock {
    
    public typealias MocksType = Signal
    
    public typealias Stubbing = __StubbingProxy_Signal
    public typealias Verification = __VerificationProxy_Signal

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Signal?

    public func enableDefaultImplementation(_ stub: Signal) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var source: Source? {
        get {
            return cuckoo_manager.getter("source",
                superclassCall:
                    
                                    super.source
                    ,
                defaultCall:  __defaultImplStub!.source)
        }
        
        set {
            cuckoo_manager.setter("source",
                value: newValue,
                superclassCall:
                    
                    super.source = newValue
                    ,
                defaultCall: __defaultImplStub!.source = newValue)
        }
        
    }
    
    
    
    
    
    public override var userInfo: [AnyHashable: Any]? {
        get {
            return cuckoo_manager.getter("userInfo",
                superclassCall:
                    
                                    super.userInfo
                    ,
                defaultCall:  __defaultImplStub!.userInfo)
        }
        
        set {
            cuckoo_manager.setter("userInfo",
                value: newValue,
                superclassCall:
                    
                    super.userInfo = newValue
                    ,
                defaultCall: __defaultImplStub!.userInfo = newValue)
        }
        
    }
    
    
    
    
    
    public override var signalName: String {
        get {
            return cuckoo_manager.getter("signalName",
                superclassCall:
                    
                                    super.signalName
                    ,
                defaultCall:  __defaultImplStub!.signalName)
        }
        
    }
    
    
    
    
    
    public override var descriptionDateFormatter: DateFormatter {
        get {
            return cuckoo_manager.getter("descriptionDateFormatter",
                superclassCall:
                    
                                    super.descriptionDateFormatter
                    ,
                defaultCall:  __defaultImplStub!.descriptionDateFormatter)
        }
        
        set {
            cuckoo_manager.setter("descriptionDateFormatter",
                value: newValue,
                superclassCall:
                    
                    super.descriptionDateFormatter = newValue
                    ,
                defaultCall: __defaultImplStub!.descriptionDateFormatter = newValue)
        }
        
    }
    
    
    
    
    
    public override var bundleName: String? {
        get {
            return cuckoo_manager.getter("bundleName",
                superclassCall:
                    
                                    super.bundleName
                    ,
                defaultCall:  __defaultImplStub!.bundleName)
        }
        
        set {
            cuckoo_manager.setter("bundleName",
                value: newValue,
                superclassCall:
                    
                    super.bundleName = newValue
                    ,
                defaultCall: __defaultImplStub!.bundleName = newValue)
        }
        
    }
    
    
    
    
    
    public override var sourceDescription: String? {
        get {
            return cuckoo_manager.getter("sourceDescription",
                superclassCall:
                    
                                    super.sourceDescription
                    ,
                defaultCall:  __defaultImplStub!.sourceDescription)
        }
        
    }
    
    
    
    
    
    public override var userInfoDescription: String? {
        get {
            return cuckoo_manager.getter("userInfoDescription",
                superclassCall:
                    
                                    super.userInfoDescription
                    ,
                defaultCall:  __defaultImplStub!.userInfoDescription)
        }
        
    }
    
    
    
    
    
    public override var valueDescription: String? {
        get {
            return cuckoo_manager.getter("valueDescription",
                superclassCall:
                    
                                    super.valueDescription
                    ,
                defaultCall:  __defaultImplStub!.valueDescription)
        }
        
    }
    
    
    
    
    
    public override var valueDebugDescription: String? {
        get {
            return cuckoo_manager.getter("valueDebugDescription",
                superclassCall:
                    
                                    super.valueDebugDescription
                    ,
                defaultCall:  __defaultImplStub!.valueDebugDescription)
        }
        
    }
    
    
    
    
    
    public override var description: String {
        get {
            return cuckoo_manager.getter("description",
                superclassCall:
                    
                                    super.description
                    ,
                defaultCall:  __defaultImplStub!.description)
        }
        
    }
    
    
    
    
    
    public override var debugDescription: String {
        get {
            return cuckoo_manager.getter("debugDescription",
                superclassCall:
                    
                                    super.debugDescription
                    ,
                defaultCall:  __defaultImplStub!.debugDescription)
        }
        
    }
    
    

    

    
    
    
    
    public override func encode(to encoder: Encoder) throws {
        
    return try cuckoo_manager.callThrows(
    """
    encode(to: Encoder) throws
    """,
            parameters: (encoder),
            escapingParameters: (encoder),
            superclassCall:
                
                super.encode(to: encoder)
                ,
            defaultCall: __defaultImplStub!.encode(to: encoder))
        
    }
    
    

    public struct __StubbingProxy_Signal: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var source: Cuckoo.ClassToBeStubbedOptionalProperty<MockSignal, Source> {
            return .init(manager: cuckoo_manager, name: "source")
        }
        
        
        
        
        var userInfo: Cuckoo.ClassToBeStubbedOptionalProperty<MockSignal, [AnyHashable: Any]> {
            return .init(manager: cuckoo_manager, name: "userInfo")
        }
        
        
        
        
        var signalName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String> {
            return .init(manager: cuckoo_manager, name: "signalName")
        }
        
        
        
        
        var descriptionDateFormatter: Cuckoo.ClassToBeStubbedProperty<MockSignal, DateFormatter> {
            return .init(manager: cuckoo_manager, name: "descriptionDateFormatter")
        }
        
        
        
        
        var bundleName: Cuckoo.ClassToBeStubbedOptionalProperty<MockSignal, String> {
            return .init(manager: cuckoo_manager, name: "bundleName")
        }
        
        
        
        
        var sourceDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String?> {
            return .init(manager: cuckoo_manager, name: "sourceDescription")
        }
        
        
        
        
        var userInfoDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String?> {
            return .init(manager: cuckoo_manager, name: "userInfoDescription")
        }
        
        
        
        
        var valueDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String?> {
            return .init(manager: cuckoo_manager, name: "valueDescription")
        }
        
        
        
        
        var valueDebugDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String?> {
            return .init(manager: cuckoo_manager, name: "valueDebugDescription")
        }
        
        
        
        
        var description: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String> {
            return .init(manager: cuckoo_manager, name: "description")
        }
        
        
        
        
        var debugDescription: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSignal, String> {
            return .init(manager: cuckoo_manager, name: "debugDescription")
        }
        
        
        
        
        
        func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(Encoder)> where M1.MatchedType == Encoder {
            let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSignal.self, method:
    """
    encode(to: Encoder) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_Signal: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var source: Cuckoo.VerifyOptionalProperty<Source> {
            return .init(manager: cuckoo_manager, name: "source", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var userInfo: Cuckoo.VerifyOptionalProperty<[AnyHashable: Any]> {
            return .init(manager: cuckoo_manager, name: "userInfo", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var signalName: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "signalName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var descriptionDateFormatter: Cuckoo.VerifyProperty<DateFormatter> {
            return .init(manager: cuckoo_manager, name: "descriptionDateFormatter", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var bundleName: Cuckoo.VerifyOptionalProperty<String> {
            return .init(manager: cuckoo_manager, name: "bundleName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var sourceDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "sourceDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var userInfoDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "userInfoDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var valueDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "valueDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var valueDebugDescription: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "valueDebugDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var description: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "description", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var debugDescription: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "debugDescription", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<(Encoder), Void> where M1.MatchedType == Encoder {
            let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
            return cuckoo_manager.verify(
    """
    encode(to: Encoder) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SignalStub: Signal {
    
    
    
    
    public override var source: Source? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Source?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var userInfo: [AnyHashable: Any]? {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AnyHashable: Any]?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var signalName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public override var descriptionDateFormatter: DateFormatter {
        get {
            return DefaultValueRegistry.defaultValue(for: (DateFormatter).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var bundleName: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var sourceDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    
    
    
    public override var userInfoDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    
    
    
    public override var valueDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    
    
    
    public override var valueDebugDescription: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
    
    
    
    public override var description: String {
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




