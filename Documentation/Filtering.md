# Filtering

One of the major ideas behind Beacon is the ability to filter signals programmatically and do so with great flexibility. This means being able to filter by arbitrary logic that may include:

* type of a signal
* values captured by a signal
* source of a signal (file, function, class)
* signal's destination - both the beacon object where signals are emitted and the loggers that observe those beacons

## Filtering with loggers

Probably the most obvious place to filter signals is at the logger level. For example, to log only errors:

```swift
ConsoleLogger.starting(name: "Console") { $0 is ErrorSignal }
```

All subclasses of `SignalLogger` accept a filter block as their final argument. If you're implementing your own logger - it's best to follow the lead here.

We can get more creative here and filter in only errors and any signal that originates from files with a certain path:

```swift
ConsoleLogger.starting(name: "Console") { aSignal in
    if aSignal is ErrorSignal { return true }
    guard let source = aSignal.source else { return false }
    return source.fileName.contains("some/path")
}
```

## Filtering with constraints

Another way of filtering signals is by constraining signals to beacons and loggers. For example, to filter out all string signals:

```swift
StringSignal.disable(loggingTo: nil, on: nil)
```

To filter in string signals across all beacons and loggers:

```swift
StringSignal.enable(loggingTo: nil, on: nil)
```

Fine tune these operations for specific loggers:

```swift
extension Beacon {
	static let debug: Beacon = .init()
}

let console = ConsoleLogger.starting(name: "Console")
let memory = MemoryLogger.starting(name: "Memory", on: [.debug])

// Disable logging of string signals across all loggers and beacons
StringSignal.disable(loggingTo: nil, on: nil)

// Enable logging of string signals to the memory logger via any beacon
StringSignal.enable(loggingTo: [memory], on: nil)

// Enable logging of string signals to any logger via 'debug' beacon
StringSignal.enable(loggingTo: nil, on: [.debug])
```

Be mindful that loggers retain their filtering block they were started with. Constraint-based filtering takes place before that block is evaluated.

## Constraints and optimizations

In the event where logging may be too expensive an operation - perhaps it's a large payload, or requires making a trip to disk or network - it may be a good idea to forego all of the required work if there aren't any loggers that would process a signal. Constraints make it possible to know this. Borrowing from earlier examples:

```swift
StringSignal.disable(loggingTo: [memory], on: nil)
willLog(type: StringSelf.self, on: [.debug]) 	// false
willLog(type: StringSelf.self, on: nil) 		// true
willLog(type: ErrorSignal.self, on: [.debug]) // true
```

This logic is used inside all `emit()` declarations. If for some reason you need to provide your own implementation of that method, be sure to check `willLog()` before emitting the actual signal! See any of the `emit()` methods for examples.