typealias T = <#WrappedType#>

public class <#Signal#>: WrapperSignal {
    var <#valueAccessor#>: T { value as! T }
    override public var signalName: String { "<#identifier#>" }
}

extension T: Signaling {
    public var beaconSignal: <#Signal#> { .init(self) }
}
