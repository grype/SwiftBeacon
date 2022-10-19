# Creating Custom Signals

There are a few types of `Signal`s defined by the framework, each capturing some specific type of value and possibly some context around it. Most types of values will be logged using a `WrapperSignal`, unless a more appropriate type exists. Defining a custom signal requires subclassing `Signal`. However, in many cases, it may be less work to just subclass `WrappedSignal` instead.

As an example, let's say we're creating a custom signal for this simple struct:

```swift
struct Duck {
    name: String
}
```

We'll call this new signal - `DuckSignal`.

## Subclassing Signal

Our subclass just needs to capture the value we want to log:

```swift
class DuckSignal: Signal {
    private(set) var duck: Duck
    
    init(_ aDuck: Duck, userInfo: [AnyHashable : Any]? = nil) {
        duck = aDuck
        super.init()
    }
}
```

`WrapperSignal` already captures the value it wraps, so it's often easier to subclass it rather than the base `Signal` class.

```swift
class DuckSignal: WrapperSignal {}
```

You would typically want to override a few properties to distinguish this new signal from others:

```swift
class DuckSignal: WrapperSignal {
    var duck: Duck { value as! Duck }
    override var signalName: String { "🦆" }
    override var valueDescription: String? { "A Duck named: \(duck.name)" }
}
```

## Using Signaling protocol

Lastly, we need to associate the value type with the new signal type so that calls to `emit()` can infer this information. This is done via the `Signaling` protocol:

```swift
extension Duck: Signaling {
    public var beaconSignal: DuckSignal { .init(self) }
}
```


All of this is captured in (this snippet)[https://github.com/grype/SwiftBeacon/blob/master/Xcode/Snippets/MakeSignal.swift], which you can easily add to XCode.