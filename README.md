# SwiftyWasmer Tests

A Swift API for the 
[Wasmer](https://wasmer.io) 
[WebAssembly](https://webassembly.org) 
Runtime.

SwiftyWasmer packages the
[Wasmer C API](https://github.com/wasmerio/wasmer-c-api)
for the Swift programming language, 
i.e. it provides `CWasmer` system library with a proper module map
and a `Wasmer` module with a nice Swift style API for Wasmer.

*Note*: This is for embedding/running 
[WebAssembly](https://webassembly.org) (Wasm)
modules from within a Swift host program. 
It is not about compiling Swift to WebAssembly
(there is the [SwiftWasm](https://swiftwasm.org) effort for this).

What does it look like? Like this:

```swift
import Wasmer

// Just load a file into memory
let wasmFile = URL(fileURLWithPath: "sum.wasm")
let wasmData = try Data(contentsOf: wasmFile)

// Compile the Data into a module, and instantiate that
let module   = try WebAssembly.Module  (wasmData)
let instance = try WebAssembly.Instance(module)

// Run a function exported by the Module
let results = try instance.exports.sum(.i32(7), .i32(8))
```

## Tests

This package contains the tests for SwiftyWasmer.
It is in a separate package because it contains some precompiled
Wasm test data that tends to be rather big.

### Links

- [SwiftyWasmer](https://github.com/AlwaysRightInstitute/SwiftyWasmer)
- [Wasmer](https://wasmer.io)

### Who

**SwiftyWasmer** is brought to you by
the
[Always Right Institute](https://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
