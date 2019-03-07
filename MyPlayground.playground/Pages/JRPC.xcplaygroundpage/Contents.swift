import Cocoa
import Beacon
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let loggers = (console: ConsoleLogger(name: "Console"),
               rpc: JRPCLogger(url: URL(string: "http://localhost:4000/")!, method: "emit", name: "jrpc"))

let allLoggers = [loggers.rpc, loggers.console]

let view = NSView(frame: NSRect.zero)

allLoggers.forEach { $0.start() }
emit()
emit("hello")
emit(12)
emit(loggers)
emit(view)
do { throw NSError(domain: "This is a test", code: 123, userInfo: nil) }
catch { emit(error: error) }
DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    allLoggers.forEach { $0.stop() }
}
