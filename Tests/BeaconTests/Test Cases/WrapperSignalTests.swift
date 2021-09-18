//
//  WrapperSignalTests.swift
//  
//
//  Created by Pavel Skaldin on 12/19/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
import Nimble
@testable import Beacon

class WrapperSignalTests: XCTestCase {
    
    func testWrappingSwiftClassValue() {
        class TestObject {
        }
        let value = TestObject()
        let signal = WrapperSignal(value)
        let val = signal.value as? TestObject
        expect(val).toNot(beNil())
    }
    
    func testWrappingNSObject() {
        class TestObject: NSObject {
        }
        let value = TestObject()
        let signal = WrapperSignal(value)
        let val = signal.value as? TestObject
        expect(val).toNot(beNil())
        expect(val) == value
    }
    
    func testWrappingString() {
        let value = "Hello World"
        let signal = WrapperSignal(value)
        let val = signal.value as? String
        expect(val).toNot(beNil())
        expect(val) == value
    }
    
    func testWrappingInt() {
        let value = 123
        let signal = WrapperSignal(value)
        let val = signal.value as? Int
        expect(val).toNot(beNil())
        expect(val) == value
    }
    
    func testWrappingBool() {
        let value = true
        let signal = WrapperSignal(value)
        let val = signal.value as? Bool
        expect(val).toNot(beNil())
        expect(val) == value
    }
    
    func testWrappingWithUserInfo() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let value = signal.value as? WrapperSignalTests
        expect(value).toNot(beNil())
        expect(value) == self
        
        let info = signal.userInfo as? [String : String]
        expect(info).toNot(beNil())
        expect(info) == userInfo
    }
    
    func testJSONEncoding() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let logger = JRPCLogger(url: URL(string: "http://example.com")!, method: "emit", name: "Test JRPC Logger")
        let encoder = logger.encoder
        let data = try! encoder.encode(signal)
        
        let decodedValue = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
        expect(decodedValue).toNot(beNil())
        expect(decodedValue!["__class"] as? String == WrapperSignal.portableClassName).to(beTrue())
        expect(decodedValue!["targetType"] as? String == String(describing: type(of: self))).to(beTrue())
        
        let dateString = decodedValue!["timestamp"] as! String
        let date = DateFormatter(format: .iso8601).date(from: dateString)
        expect(date).toNot(beNil())
        expect(abs(signal.timestamp.timeIntervalSince(date!))).to(beLessThanOrEqualTo(1))
        
        let properties = decodedValue!["properties"] as? [String : String]
        expect(properties) == userInfo
    }
    
    func testInTimeDescription() {
        let foo = Mutable()
        foo.string = "First"
        
        let signal = WrapperSignal(foo)
        expect(signal.valueDescription) == "First"
        
        foo.string = "Changed"
        expect(signal.valueDescription) == "Changed"
    }
}

class Mutable : CustomStringConvertible {
    var string: String?
    var description: String { string ?? "" }
}
