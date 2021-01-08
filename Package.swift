// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "SwiftyWasmerTests",
  
  products: [],
  
  dependencies: [
    // https://github.com/AlwaysRightInstitute/SwiftyWasmer
    .package(url: "file:///Users/helge/dev/Swift/ARI/SwiftyWasmer/", 
             .branch("develop"))
  ],
  
  targets: [
    .testTarget(name: "WasmerTests", dependencies: [ 
      .product(name: "Wasmer", package: "SwiftyWasmer") 
    ])
  ]
)
