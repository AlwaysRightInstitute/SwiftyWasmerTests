import struct Foundation.Data
import struct Foundation.URL

enum Fixtures {
  
  static let wasmPath =
     URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .appendingPathComponent("Fixtures")
      .appendingPathComponent("wasm")
  
  enum Plain {
    static let rustSumPath =
      wasmPath.appendingPathComponent("rust-sum-simple-release.wasm")
    static let rustSumData = try! Data(contentsOf: rustSumPath)
  }
  enum WASI {
    static let rustSumPath =
      wasmPath.appendingPathComponent("rust-sum-wasi-release.wasm")
    static let rustSumData = try! Data(contentsOf: rustSumPath)
  }
}
