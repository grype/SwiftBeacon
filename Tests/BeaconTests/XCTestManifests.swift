import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BeaconTests.allTests),
        testCase(MemoryLoggerTests.allTests),
        testCase(SignalLoggerTests.allTests),
        testCase(SignalTests.allTests),
        testCase(SignalStringEncoderTests.allTests),
        testCase(StreamLoggerTests.allTests),
        testCase(WrapperSignalTests.allTests),
    ]
}
#endif
