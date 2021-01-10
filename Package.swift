// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "SwiftyWasmerTests",
  
  products: [],
  
  dependencies: [
    .package(url: "https://github.com/AlwaysRightInstitute/SwiftyWasmer", 
             .branch("develop"))
  ],
  
  targets: [
    .testTarget(name: "WasmerTests", dependencies: [ 
      .product(name: "Wasmer", package: "SwiftyWasmer") 
    ])
  ]
)
