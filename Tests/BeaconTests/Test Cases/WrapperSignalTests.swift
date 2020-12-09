//
//  WrapperSignalTests.swift
//  
//
//  Created by Pavel Skaldin on 12/19/19.
//

import XCTest
@testable import Beacon

class WrapperSignalTests: XCTestCase {
    
    func testWrappingSwiftClassValue() {
        class TestObject {
        }
        let value = TestObject()
        let signal = WrapperSignal(value)
        let val = signal.value as? TestObject
        XCTAssertTrue(val != nil, "Failed to wrap \(type(of: value))")
    }
    
    func testWrappingNSObject() {
        class TestObject: NSObject {
        }
        let value = TestObject()
        let signal = WrapperSignal(value)
        let val = signal.value as? TestObject
        XCTAssertTrue(val != nil, "Failed to wrap \(type(of: value))")
        XCTAssertTrue(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingString() {
        let value = "Hello World"
        let signal = WrapperSignal(value)
        let val = signal.value as? String
        XCTAssertTrue(val != nil, "Failed to wrap \(type(of: value))")
        XCTAssertTrue(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingInt() {
        let value = 123
        let signal = WrapperSignal(value)
        let val = signal.value as? Int
        XCTAssertTrue(val != nil, "Failed to wrap \(type(of: value))")
        XCTAssertTrue(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingBool() {
        let value = true
        let signal = WrapperSignal(value)
        let val = signal.value as? Bool
        XCTAssertTrue(val != nil, "Failed to wrap \(type(of: value))")
        XCTAssertTrue(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingWithUserInfo() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let value = signal.value as? WrapperSignalTests
        XCTAssertTrue(value != nil, "Failed to wrap value")
        XCTAssertTrue(value == self, "Incorrectly wrapped value")
        
        let info = signal.userInfo as? [String : String]
        XCTAssertTrue(info != nil, "Failed to wrap userInfo")
        XCTAssertTrue(info == userInfo, "Incorrectly wrapped userInfo")
    }
    
    func testJSONEncoding() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(signal)
        XCTAssertTrue(data != nil, "Failed to encode WrappedSignal with encodable user info")
        print(String(data: data!, encoding: .utf8)!)
        
        let decodedValue = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any]
        XCTAssertTrue(decodedValue != nil, "Failed to decode encoded WrappedSignal")
        XCTAssertTrue(decodedValue!["__class"] as? String == WrapperSignal.portableClassName, "Incorrectly encoded remote value type")
        XCTAssertTrue(decodedValue!["targetType"] as? String == String(describing: type(of: self)), "Incorrectly encoded local value type")
        
        let dateString = decodedValue!["timestamp"] as! String
        let dateFormatter = signal.dateFormatter
        let date = dateFormatter.date(from: dateString)
        XCTAssertTrue(date != nil, "Failed to decode timestamp")
        XCTAssertLessThanOrEqual(abs(signal.timestamp.timeIntervalSince(date!)), 1, "Incorrectly encoded value type")
        
        let properties = decodedValue!["properties"] as? [String : String]
        XCTAssertTrue(properties == userInfo, "Incorrectly encoded userInfo")
    }
    
    func testInTimeDescription() {
        var foo = "First"
        var info = ["Foo": "I am Foo"]
        
        let signal = WrapperSignal(foo, userInfo: info)
        
        let valueDescription = signal.valueDescription
        let userInfoDescription = signal.userInfoDescription
        let description = signal.description
        
        foo.append("<CHANGED>")
        info["Bar"] = "I am foo"
        
        XCTAssertEqual(signal.valueDescription, valueDescription, "Incorrectly captured value description")
        XCTAssertEqual(signal.userInfoDescription, userInfoDescription, "Incorrectly captured value description")
        XCTAssertEqual(signal.description, description, "Incorrectly captured description")
    }
}
