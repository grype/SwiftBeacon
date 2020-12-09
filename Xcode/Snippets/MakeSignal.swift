class <#Signal#> : WrapperSignal {
    typealias T = <#WrappedType#>
    
    var <#accessor#>: T {
        return value as! T
    }
    
    override var signalName: String {
        return "<#identifier#>"
    }
    
}

extension <#WrappedType#> : Signaling {
    public var beaconSignal: Signal {
        return <#Signal#>(self)
    }
}

func emit(_ value: <#WrappedType#>, on beacon: Beacon = Beacon.shared, userInfo: [AnyHashable : Any]? = nil, fileName: String = #file, line: Int = #line, functionName: String = #function) {
    <#Signal#>(value).emit(on: [beacon], userInfo: userInfo, fileName: fileName, line: line, functionName: functionName)
}
