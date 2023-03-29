# Signal flow

Beacon uses the Observer pattern to implement the flow of signals to loggers. Whenever you call `emit()` a signal is created and emitted on one or more beacons. Whenever you start a logger, you indicate which beacons to observe. So when a signal is emitted on a beacon, the interested loggers respond by logging it in an appropriate manner. For example,

```swift
let logger = MemoryLogger(name: "Memory")
logger.run(on: [.shared]) { _ in
	emit("Hello World", on: [.shared])
}
```

Here we're starting a memory logger on a shared beacon and then emitting a string signal on the same beacon. The `emit()` method can be rewritten as:

```swift
StringSignal("Hello World").emit(on: [.shared])
```

Note: the shared beacon is implied whenever you don't specify which beacons to observe or emit signals on.

This design makes it possible to combine multiple loggers and beacons. For example, we could create two groups of loggers, with one group logging all errors to, say, the console and a file, and another group that logs only certain types of signals to a remote service - e.g. Segment, Firebase, or what have you.

## Logging via multiple Beacons

Building on the example above, let's set up two groups of beacons and loggers to capture different types of signals.

```swift
extension Beacon {
	static let remote: Beacon = .init()
}

let loggers = (
	console: ConsoleLogger.starting(name: "Console", on: [.shared]),
	remote: JRPCLogger.starting(url: URL(string: "http://localhost:4000")!, 
		method: "emit", 
		name: "Remote",
		on: [.remote])
)

emit("Hello world", on: [.shared, .remote])
```

Here we create another Beacon, named 'remote' so that we can explicitly emit signals there. Then we start two loggers - a console logger runs on the shared beacon, while a JSON-RPC logger runs the dedicated 'remote' beacon. We then emit a string signal on both beacons, which results in it being logged to both the console and JRPC logger.

Getting a little more creative, let's say we created a logger for logging certain events to Segment, and another logger for logging all errors to Crashlytics.

```swift
extension Beacon {
	static let crashlytics: Beacon = .init()
	static let segment: Beacon = .init()
	
	static let eventBeacons: [Beacon] = [.shared, .segment]
	static let errorBeacons: [Beacon] = [.shared, .crashlytics]
}

let loggers = (
	console: ConsoleLogger.starting(name: "Console"),
	segment: SegmentLogger.starting(...),
	crashlytics: CrashlyticsLogger.starting(...) { $0 is ErrorSignal }
)

do {
	emit("Start risky operation", on: Beacon.eventBeacons)
	...
	emit("Finished risky operation", on: Beacon.eventBeacons)
}
catch {
	emit(error: error, on: Beacon.errorBeacons)
}
```