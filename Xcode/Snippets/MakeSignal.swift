public typealias T = <#WrappedType#>

public class <#Signal#>: WrapperSignal {
    var <#wrappedValue#>: T { value as! T }
    public init(_ aValue: T, userInfo anUserInfo: [AnyHashable: Any]? = nil) {
        super.init(aValue)
    }

    override public var signalName: String { "<#identifier#>" }
    override public var valueDescription: String? { super.valueDescription }
}

extension T: Signaling {
    public var beaconSignal: <#Signal#> { .init(self) }
}
