//
//  Foundation+Extensions.swift
//
//
//  Created by Pavel Skaldin on 12/2/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import ObjectiveC

// MARK: - Class Hierarchy

var allClasses: [AnyClass] {
    var count = Int(objc_getClassList(nil, 0))
    guard count > 0 else { return [] }

    let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: count)
    let autoreleasingClassesPtr = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
    count = Int(objc_getClassList(autoreleasingClassesPtr, Int32(count)))

    defer { classesPtr.deallocate() }
    return (0 ..< count).map { classesPtr[$0] }
}

func superclasses(of aClass: AnyClass) -> [AnyClass] {
    guard let superClass = aClass.superclass() else { return [] }
    var temp = superclasses(of: superClass)
    temp.insert(superClass, at: 0)
    return temp
}

func subclasses(of baseClass: AnyClass) -> [AnyClass] {
    allClasses.filter { aClass in
        var ancestor: AnyClass? = aClass
        while let type = ancestor {
            guard ObjectIdentifier(type) == ObjectIdentifier(baseClass) else {
                ancestor = class_getSuperclass(type)
                continue
            }
            return ObjectIdentifier(baseClass) != ObjectIdentifier(aClass)
        }
        return false
    }
}

// MARK: - Protocol Conformance

func classes(conformingTo protocol: Protocol) -> [AnyClass] {
    let classes = allClasses.filter { aClass in
        var subject: AnyClass? = aClass
        while let aClass = subject {
            if class_conformsToProtocol(aClass, `protocol`) { print(String(describing: aClass)); return true }
            subject = class_getSuperclass(aClass)
        }
        return false
    }
    return classes
}

func classes<T>(conformTo: T.Type) -> [AnyClass] {
    return allClasses.filter { $0 is T }
}

// MARK: - Extensions

extension NSObject {
    class var withAllSuperclasses: [AnyClass] {
        [self] + superclasses(of: self)
    }

    class var withAllSubclasses: [AnyClass] {
        [self] + subclasses(of: self)
    }
}
