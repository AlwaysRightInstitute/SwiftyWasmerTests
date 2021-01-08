import XCTest
@testable import Wasmer

final class WasmerTests: XCTestCase {
  
  func testValidation() throws {
    let ok = WebAssembly.validate(Fixtures.Plain.rustSumData)
    XCTAssertTrue(ok)
    
    let nonsense = Data([ 1, 2, 3, 4 ])
    let ok2 = WebAssembly.validate(nonsense)
    XCTAssertFalse(ok2)
  }
  
  func testCompilation() throws {
    let module = try WebAssembly.Module(Fixtures.Plain.rustSumData)
    XCTAssertNotNil(module)
    print("Module:", module)
  }
  
  func testFileCompilation() throws {
    let module = try WebAssembly.Module(contentsOf: Fixtures.Plain.rustSumPath)
    XCTAssertNotNil(module)
    print("Module:", module)
  }
  
  func testModuleInstantiation() throws {
    let module = try WebAssembly.Module(contentsOf: Fixtures.Plain.rustSumPath)
    print("Module:", module)
    
    let instance = try WebAssembly.Instance(module)
    print("Instance:", instance)
  }
  
  func testDataInstantiation() throws {
    let instance = try WebAssembly.Instance(Fixtures.Plain.rustSumData)
    print("Instance:", instance)
  }

  func testDataInstantiationWithPlainImports() throws {
    let imports = WebAssembly.ImportObject(defaultModule: "env", core: .plain)
    imports[name: "memory"]        = try WebAssembly.Memory()
    imports[name: "__memory_base"] = WebAssembly.Global(.i32(1024))
    XCTAssertEqual(imports.count, 2)
    
    let instance =
      try WebAssembly.Instance(Fixtures.Plain.rustSumData, imports)
    print("Instance:", instance)
  }

  func testExportsSimpleSum() throws {
    let instance = try WebAssembly.Instance(Fixtures.Plain.rustSumData)

    do {
      let results = try instance.exports.sum(.i32(7), .i32(8))
      XCTAssertEqual(results.count, 1)
      guard let result = results.first else { return }
      XCTAssertEqual(result, .i32(15))
    }
    do {
      let results = try instance.exports.sum(.i32(10), .i32(8))
      XCTAssertEqual(results.count, 1)
      guard let result = results.first else { return }
      XCTAssertEqual(result, .i32(18))
    }
  }

  func testExports() throws {
    let instance = try WebAssembly.Instance(Fixtures.Plain.rustSumData)
    print("Instance:", instance)
    
    let exports = instance.exports
    print("number of exports: #\(exports.count)")
    XCTAssertEqual(exports.count, 4)

    // Note: we currently only get 2 here
    for export in exports {
      print("EXPORT:", export)
    }
  }

  func testMissingImportsWasiSum() throws {
    do {
      _ = try WebAssembly.Instance(Fixtures.WASI.rustSumData,
                                   .init(core: .plain))
      XCTAssertTrue(false, "Missing expected error!")
    }
    catch let error as WasmerError {
      guard case .importError = error else {
        XCTAssertTrue(false, "Unexpected wasmer error: \(error)"); return
      }
    }
    catch {
      XCTAssertTrue(false, "Unexpected error: \(error)"); return
    }
  }

  func testDefaultWasiSum() throws {
    let imports = WebAssembly.ImportObject(defaultModule: "env")
    imports[name: "memory"]        = try WebAssembly.Memory()
    imports[name: "__memory_base"] = WebAssembly.Global(.i32(1024))

    let instance = try WebAssembly.Instance(Fixtures.WASI.rustSumData, imports)

    do {
      let results = try instance.exports.sum(.i32(7), .i32(8))
      XCTAssertEqual(results.count, 1)
      guard let result = results.first else { return }
      XCTAssertEqual(result, .i32(15))
    }
  }

  func testInvalidArgumentsCall() throws {
    let instance = try WebAssembly.Instance(Fixtures.Plain.rustSumData)
    
    do {
      _ = try instance.exports.sum(.f32(7), .i64(8))
      XCTAssertTrue(false, "Missing expected error!")
    }
    catch let error as WasmerError {
      guard case .runtime(let reason) = error else {
        XCTAssertTrue(false, "Unexpected wasmer error: \(error)"); return
      }
      XCTAssert(reason.contains("did not match signature"),
                "missing invalid signature reason")
    }
    catch {
      XCTAssertTrue(false, "Unexpected error: \(error)"); return
    }
  }
  
  #if WASMER_IMPORT_OBJECT_WORKS
  func testWASIImportWithArgs() throws {
    let wasi = WASI.Configuration(
      arguments   : [ "a one", "a one", "a one" ],
      environment : [ "two": "three" ]
    )
    
    let imports = WebAssembly.ImportObject(defaultModule: "env",
                                           core: .wasi(wasi))
    let instance = try WebAssembly.Instance(wasiSumData, imports)

    do {
      let results = try instance.exports.sum(.i32(7), .i32(8))
      XCTAssertEqual(results.count, 1)
      guard let result = results.first else { return }
      XCTAssertEqual(result, .i32(15))
    }
  }
  #endif // WASMER_IMPORT_OBJECT_WORKS

  static var allTests = [
    ( "testValidation"                   , testValidation                   ),
    ( "testCompilation"                  , testCompilation                  ),
    ( "testFileCompilation"              , testFileCompilation              ),
    ( "testModuleInstantiation"          , testModuleInstantiation          ),
    ( "testDataInstantiation"            , testDataInstantiation            ),
    ( "testDataInstantiationWithPlainImports",
       testDataInstantiationWithPlainImports ),
    ( "testExports"                      , testExports                      ),
    ( "testExportsSimpleSum"             , testExportsSimpleSum             ),
    ( "testMissingImportsWasiSum"        , testMissingImportsWasiSum        ),
    ( "testDefaultWasiSum"               , testDefaultWasiSum               ),
    ( "testInvalidArgumentsCall"         , testInvalidArgumentsCall         ),
    /* #if WASMER_IMPORT_OBJECT_WORKS
    ( "testWASIImportWithArgs"           , testWASIImportWithArgs           ),
    #endif */
  ]
}
