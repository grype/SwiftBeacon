import Beacon
import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension String: Error {}

JRPCLogger(url: URL(string: "http://localhost:4000/")!, method: "emit", name: "jrpc").run { _ in
    emit()
    emit("hello")
    emit(Date())
    do { throw "🦝" } catch { emit(error: error) }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    PlaygroundPage.current.finishExecution()
}
