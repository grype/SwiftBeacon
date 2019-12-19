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
        
    }
    
    func testWrappingNSObject() {
        
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
}
