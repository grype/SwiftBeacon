# Symbolicating stack traces

Certain signals are designed to capture a stack trace that lead to emitting them. Such signals are `ContextSignal` and `ErrorSignal`. However, if the binary was stripped of DSYMs, these stack traces will be rather crypting, only showing a memory address. In order to symbolicate those stack traces we need to know a couple of things:

1. We need to know the load address of the binary and all the MachO images it loads
2. The host's architecture

In order to collect this information at run time, there exist two special signals:

- `IdentitySignal`, which captures some basic information about the host, including the architecture.
- `MachImageImportsSignal`, which captures added/removed MachO images.

Before starting a logger, configure it by setting `identifiesOnStart` and `tracksMachImageImports` to true. This will cause the logger to immediately emit `IdentitySignal` when started, and to start emitting `MachImageImportsSignal` whenever MachO images are un-/loaded.

Once you know the architecture and the load addresses, use `atos` utility to look up addresses mentioned in the stack traces.