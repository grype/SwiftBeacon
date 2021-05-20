//
//  MachImageMonitor.swift
//
//
//  Created by Pavel Skaldin on 5/7/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation
import MachO
import RWLock
import SwiftAnnouncements

open class MachImageMonitor {
    
    // MARK:- Types
    
    public enum Announcement : Announceable {
        case didAddImage(MachImage), didRemoveImage(MachImage)
    }
    
    // MARK:- API
    
    public static var shared = MachImageMonitor()
    
    @RWLocked private(set) static var isRunning = false
    
    public static func startMonitoring() {
        guard !isRunning else { return }
        isRunning = true
        _dyld_register_func_for_add_image { (aHeader, _) in
            guard let aHeader = aHeader else { return }
            MachImageMonitor.shared.didAddImage(aHeader)
        }
    }
    
    public static func stopMonitoring() {
        guard isRunning else { return }
        _dyld_register_func_for_remove_image { (aHeader, _) in
            guard let aHeader = aHeader else { return }
            MachImageMonitor.shared.didRemoveImage(aHeader)
        }
        isRunning = false
    }
    
    // MARK:- Properties
    
    @RWLocked public private(set) var images = [MachImage]()
    
    public private(set) var announcer = Announcer()
    
    // MARK:- Adding/Removing Images
    
    private func didAddImage(_ aHeader: UnsafePointer<mach_header>) {
        let index = UInt32(images.count)
        guard let image = MachImage(at: index),
              image.address == Int(bitPattern: aHeader)
        else {
            print("Could not find added image at: \(String(describing: aHeader))")
            return
        }
        images.append(image)
        announcer.announce(Announcement.didAddImage(image))
    }
    
    private func didRemoveImage(_ aHeader: UnsafePointer<mach_header>) {
        let address = Int(bitPattern: aHeader)
        guard let image = images.first(where: { $0.address == address })
        else {
            print("Could not find image to remove at: \(String(describing: aHeader))")
            return
        }
        announcer.announce(Announcement.didRemoveImage(image))
    }

}
