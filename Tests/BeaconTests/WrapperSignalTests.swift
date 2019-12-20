//
//  File.swift
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
        assert(val != nil, "Failed to wrap \(type(of: value))")
    }
    
    func testWrappingNSObject() {
        class TestObject: NSObject {
        }
        let value = TestObject()
        let signal = WrapperSignal(value)
        let val = signal.value as? TestObject
        assert(val != nil, "Failed to wrap \(type(of: value))")
        assert(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingString() {
        let value = "Hello World"
        let signal = WrapperSignal(value)
        let val = signal.value as? String
        assert(val != nil, "Failed to wrap \(type(of: value))")
        assert(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingInt() {
        let value = 123
        let signal = WrapperSignal(value)
        let val = signal.value as? Int
        assert(val != nil, "Failed to wrap \(type(of: value))")
        assert(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingBool() {
        let value = true
        let signal = WrapperSignal(value)
        let val = signal.value as? Bool
        assert(val != nil, "Failed to wrap \(type(of: value))")
        assert(val == value, "Incorrectly wrapped \(type(of: value))")
    }
    
    func testWrappingWithUserInfo() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let value = signal.value as? WrapperSignalTests
        assert(value != nil, "Failed to wrap value")
        assert(value == self, "Incorrectly wrapped value")
        
        let info = signal.userInfo as? [String : String]
        assert(info != nil, "Failed to wrap userInfo")
        assert(info == userInfo, "Incorrectly wrapped userInfo")
    }
    
    func testJSONEncoding() {
        let userInfo: [String : String] = ["Hello" : "World"]
        let signal = WrapperSignal(self, userInfo: userInfo)
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(signal)
        assert(data != nil, "Failed to encode WrappedSignal with encodable user info")
        print(String(data: data!, encoding: .utf8)!)
        
        let decodedValue = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any]
        assert(decodedValue != nil, "Failed to decode encoded WrappedSignal")
        assert(decodedValue!["__class"] as? String == WrapperSignal.portableClassName, "Incorrectly encoded remote value type")
        assert(decodedValue!["targetType"] as? String == String(describing: type(of: self)), "Incorrectly encoded local value type")
        
        let dateString = decodedValue!["timestamp"] as! String
        let dateFormatter = signal.dateFormatter
        let date = dateFormatter.date(from: dateString)
        assert(date != nil, "Failed to decode timestamp")
        assert(abs(signal.timestamp.timeIntervalSince(date!)) < 1, "Incorrectly encoded value type")
        
        let properties = decodedValue!["properties"] as? [String : String]
        assert(properties == userInfo, "Incorrectly encoded userInfo")
    }
}
