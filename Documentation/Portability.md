# Portability

Signals are locally defined types. When it comes down to logging them it's a good idea to identify those signals somehow, so that whatever is digesting those signals can distinguish between them. This is achieved using the `Encoding` protocol. If a signal has a `portableClassName` it will be encoded along with everything else. By default this is a string representing the name of the signal type.

Whenever you digest logged signals, you can refer to the portable type by looking in the "__class" property of the encoded data. For example, if we're encoding in JSON:

```swift
let memory = MemoryLogger(name: "Memory")

memory.run { _ in
	emit("Hello world!")
}

let signal = memory.recordings.first!
let data = try! JSONEncoder().encode(signal)
let jsonObject = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
assert((jsonObject["__class"] as! String) == "StringSignal")
```

This information could be used for interacting with other services where this information is needed. For example, [Beacon-Server](https://github.com/grype/Beacon-Server) uses this information to map JSON data to its local types.