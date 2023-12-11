//
//  SignalLogger.swift
//  Beacon
//
//  Created by Pavel Skaldin on 10/20/18.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Combine
import Foundation

/**
 I am an abstract logger of `Signal`s.
 
 There exist a few concrete subclasses of me, like `ConsoleLogger` and `MemoryLogger`.
 
 I carry a `name` to disinguish myself from other loggers. I also keep a reference to the `Beacon`
 on which I observe signals, defaulting to `Beacon.shared` instance.
 
 **Subclassing notes**
 
 - At the bare minumum, override `nextPut(_:)`. In that method, take care of handling the signal.
 - Override `nextPutAll(_:)` if special care is needed when handling multiple signals.
 - Override `description` for customizing my description.
 
 **Identifying a client**
 
 It may be beneficial to identify the client whenever the logger starts. Especially when utilizing a logger in production, on remote machines. There exists a special `IdentifySignal` that captures particulars about the machine. I can be configured to emit that signal when it is started via `identifiesOnStart`.
 
 **Tracking framework loading**
 
 It may be beneficial to track when MachO images are being loaded - this happens whenever a framework gets loaded. Doing so will help with symbolication of stack traces, when working with binaries with stripped symbols. Crashlogs automatically capture this information, but emitting an error or context signals, doesn't really provide all the particulars needed to symbolicate the stack trace.
 
 For that reason, I can be configured to track image un-/loading via the `tracksMachImageImports` property. When true, I will emit `MachOImageImportsSignal` whenever an image is loaded or unloaded, and I will also emit a signal with all of the already loaded images whenever I am started.
 
 - See Also: `ConsoleLogger`, `MemoryLogger`
 */
public protocol SignalLogger: Subscriber {
    // MARK: - Properties
    
    /// Logger name.
    /// Used to distinguish one logger from another.
    var name: String { get }
}
