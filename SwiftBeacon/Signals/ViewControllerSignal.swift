//
//  ViewControllerSignal.swift
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 2/15/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import UIKit

/**
 I am a `BeaconSignal' that represents an `UIViewController`.
 
 I am mostly useful for signaling instances of UIViewController at different states.
 */
class ViewControllerSignal: BeaconSignal {
    private(set) var controller: UIViewController
    
    public override class var signalName: String {
        return "👁 \(classSignalName)"
    }
    
    public init(_ aController: UIViewController) {
        controller = aController
        super.init()
    }
    
    public override var description: String {
        return "\(super.description) \(controller.description)"
    }
}

extension UIViewController : BeaconSignaling {
    public var beaconSignal: BeaconSignal {
        return ViewControllerSignal(self)
    }
}
