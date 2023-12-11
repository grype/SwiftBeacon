import Cuckoo
@testable import Beacon

import Foundation






public class MockFileBackupWheel: FileBackupWheel, Cuckoo.ClassMock {
    
    public typealias MocksType = FileBackupWheel
    
    public typealias Stubbing = __StubbingProxy_FileBackupWheel
    public typealias Verification = __VerificationProxy_FileBackupWheel

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: FileBackupWheel?

    public func enableDefaultImplementation(_ stub: FileBackupWheel) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var maxFileSize: UInt64 {
        get {
            return cuckoo_manager.getter("maxFileSize",
                superclassCall:
                    
                                    super.maxFileSize
                    ,
                defaultCall:  __defaultImplStub!.maxFileSize)
        }
        
        set {
            cuckoo_manager.setter("maxFileSize",
                value: newValue,
                superclassCall:
                    
                    super.maxFileSize = newValue
                    ,
                defaultCall: __defaultImplStub!.maxFileSize = newValue)
        }
        
    }
    
    
    
    
    
    public override var maxNumberOfBackups: Int {
        get {
            return cuckoo_manager.getter("maxNumberOfBackups",
                superclassCall:
                    
                                    super.maxNumberOfBackups
                    ,
                defaultCall:  __defaultImplStub!.maxNumberOfBackups)
        }
        
        set {
            cuckoo_manager.setter("maxNumberOfBackups",
                value: newValue,
                superclassCall:
                    
                    super.maxNumberOfBackups = newValue
                    ,
                defaultCall: __defaultImplStub!.maxNumberOfBackups = newValue)
        }
        
    }
    
    
    
    
    
    public override var fileManager: FileManager {
        get {
            return cuckoo_manager.getter("fileManager",
                superclassCall:
                    
                                    super.fileManager
                    ,
                defaultCall:  __defaultImplStub!.fileManager)
        }
        
        set {
            cuckoo_manager.setter("fileManager",
                value: newValue,
                superclassCall:
                    
                    super.fileManager = newValue
                    ,
                defaultCall: __defaultImplStub!.fileManager = newValue)
        }
        
    }
    
    
    
    
    
    public override var dateFormatter: DateFormatter {
        get {
            return cuckoo_manager.getter("dateFormatter",
                superclassCall:
                    
                                    super.dateFormatter
                    ,
                defaultCall:  __defaultImplStub!.dateFormatter)
        }
        
        set {
            cuckoo_manager.setter("dateFormatter",
                value: newValue,
                superclassCall:
                    
                    super.dateFormatter = newValue
                    ,
                defaultCall: __defaultImplStub!.dateFormatter = newValue)
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
    
    
    
    
    
    public override func rotate(fileAt aURL: URL) throws {
        
    return try cuckoo_manager.callThrows(
    """
    rotate(fileAt: URL) throws
    """,
            parameters: (aURL),
            escapingParameters: (aURL),
            superclassCall:
                
                super.rotate(fileAt: aURL)
                ,
            defaultCall: __defaultImplStub!.rotate(fileAt: aURL))
        
    }
    
    
    
    
    
    public override func backupFile(at aURL: URL) throws {
        
    return try cuckoo_manager.callThrows(
    """
    backupFile(at: URL) throws
    """,
            parameters: (aURL),
            escapingParameters: (aURL),
            superclassCall:
                
                super.backupFile(at: aURL)
                ,
            defaultCall: __defaultImplStub!.backupFile(at: aURL))
        
    }
    
    
    
    
    
    public override func deleteOldBackupsOfFile(at aURL: URL) throws {
        
    return try cuckoo_manager.callThrows(
    """
    deleteOldBackupsOfFile(at: URL) throws
    """,
            parameters: (aURL),
            escapingParameters: (aURL),
            superclassCall:
                
                super.deleteOldBackupsOfFile(at: aURL)
                ,
            defaultCall: __defaultImplStub!.deleteOldBackupsOfFile(at: aURL))
        
    }
    
    
    
    
    
    public override func backupsOfFile(at aURL: URL) throws -> [URL] {
        
    return try cuckoo_manager.callThrows(
    """
    backupsOfFile(at: URL) throws -> [URL]
    """,
            parameters: (aURL),
            escapingParameters: (aURL),
            superclassCall:
                
                super.backupsOfFile(at: aURL)
                ,
            defaultCall: __defaultImplStub!.backupsOfFile(at: aURL))
        
    }
    
    
    
    
    
    public override func nextBackupURLFor(url: URL) -> URL {
        
    return cuckoo_manager.call(
    """
    nextBackupURLFor(url: URL) -> URL
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.nextBackupURLFor(url: url)
                ,
            defaultCall: __defaultImplStub!.nextBackupURLFor(url: url))
        
    }
    
    
    
    
    
    public override func fileExists(at url: URL) -> Bool {
        
    return cuckoo_manager.call(
    """
    fileExists(at: URL) -> Bool
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.fileExists(at: url)
                ,
            defaultCall: __defaultImplStub!.fileExists(at: url))
        
    }
    
    
    
    
    
    public override func fileSize(at url: URL) -> UInt64 {
        
    return cuckoo_manager.call(
    """
    fileSize(at: URL) -> UInt64
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.fileSize(at: url)
                ,
            defaultCall: __defaultImplStub!.fileSize(at: url))
        
    }
    
    

    public struct __StubbingProxy_FileBackupWheel: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var maxFileSize: Cuckoo.ClassToBeStubbedProperty<MockFileBackupWheel, UInt64> {
            return .init(manager: cuckoo_manager, name: "maxFileSize")
        }
        
        
        
        
        var maxNumberOfBackups: Cuckoo.ClassToBeStubbedProperty<MockFileBackupWheel, Int> {
            return .init(manager: cuckoo_manager, name: "maxNumberOfBackups")
        }
        
        
        
        
        var fileManager: Cuckoo.ClassToBeStubbedProperty<MockFileBackupWheel, FileManager> {
            return .init(manager: cuckoo_manager, name: "fileManager")
        }
        
        
        
        
        var dateFormatter: Cuckoo.ClassToBeStubbedProperty<MockFileBackupWheel, DateFormatter> {
            return .init(manager: cuckoo_manager, name: "dateFormatter")
        }
        
        
        
        
        
        func shouldRotate<M1: Cuckoo.Matchable>(fileAt url: M1) -> Cuckoo.ClassStubFunction<(URL), Bool> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    shouldRotate(fileAt: URL) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rotate<M1: Cuckoo.Matchable>(fileAt aURL: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    rotate(fileAt: URL) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func backupFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    backupFile(at: URL) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func deleteOldBackupsOfFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    deleteOldBackupsOfFile(at: URL) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func backupsOfFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.ClassStubThrowingFunction<(URL), [URL]> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    backupsOfFile(at: URL) throws -> [URL]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func nextBackupURLFor<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.ClassStubFunction<(URL), URL> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    nextBackupURLFor(url: URL) -> URL
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fileExists<M1: Cuckoo.Matchable>(at url: M1) -> Cuckoo.ClassStubFunction<(URL), Bool> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    fileExists(at: URL) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fileSize<M1: Cuckoo.Matchable>(at url: M1) -> Cuckoo.ClassStubFunction<(URL), UInt64> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFileBackupWheel.self, method:
    """
    fileSize(at: URL) -> UInt64
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FileBackupWheel: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var maxFileSize: Cuckoo.VerifyProperty<UInt64> {
            return .init(manager: cuckoo_manager, name: "maxFileSize", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var maxNumberOfBackups: Cuckoo.VerifyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "maxNumberOfBackups", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var fileManager: Cuckoo.VerifyProperty<FileManager> {
            return .init(manager: cuckoo_manager, name: "fileManager", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var dateFormatter: Cuckoo.VerifyProperty<DateFormatter> {
            return .init(manager: cuckoo_manager, name: "dateFormatter", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func rotate<M1: Cuckoo.Matchable>(fileAt aURL: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return cuckoo_manager.verify(
    """
    rotate(fileAt: URL) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func backupFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return cuckoo_manager.verify(
    """
    backupFile(at: URL) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func deleteOldBackupsOfFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return cuckoo_manager.verify(
    """
    deleteOldBackupsOfFile(at: URL) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func backupsOfFile<M1: Cuckoo.Matchable>(at aURL: M1) -> Cuckoo.__DoNotUse<(URL), [URL]> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: aURL) { $0 }]
            return cuckoo_manager.verify(
    """
    backupsOfFile(at: URL) throws -> [URL]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func nextBackupURLFor<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.__DoNotUse<(URL), URL> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    nextBackupURLFor(url: URL) -> URL
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fileExists<M1: Cuckoo.Matchable>(at url: M1) -> Cuckoo.__DoNotUse<(URL), Bool> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    fileExists(at: URL) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fileSize<M1: Cuckoo.Matchable>(at url: M1) -> Cuckoo.__DoNotUse<(URL), UInt64> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    fileSize(at: URL) -> UInt64
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FileBackupWheelStub: FileBackupWheel {
    
    
    
    
    public override var maxFileSize: UInt64 {
        get {
            return DefaultValueRegistry.defaultValue(for: (UInt64).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var maxNumberOfBackups: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var fileManager: FileManager {
        get {
            return DefaultValueRegistry.defaultValue(for: (FileManager).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public override var dateFormatter: DateFormatter {
        get {
            return DefaultValueRegistry.defaultValue(for: (DateFormatter).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
    public override func shouldRotate(fileAt url: URL) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public override func rotate(fileAt aURL: URL) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func backupFile(at aURL: URL) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func deleteOldBackupsOfFile(at aURL: URL) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func backupsOfFile(at aURL: URL) throws -> [URL]  {
        return DefaultValueRegistry.defaultValue(for: ([URL]).self)
    }
    
    
    
    
    
    public override func nextBackupURLFor(url: URL) -> URL  {
        return DefaultValueRegistry.defaultValue(for: (URL).self)
    }
    
    
    
    
    
    public override func fileExists(at url: URL) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public override func fileSize(at url: URL) -> UInt64  {
        return DefaultValueRegistry.defaultValue(for: (UInt64).self)
    }
    
    
}




