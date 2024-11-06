// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import PackageDescription

let package = Package(
    name: "GetSimpleClient",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(name: "Arrow", path: "vendor/Arrow"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "GetSimpleClient",
            dependencies: [
                .product(name: "Arrow", package: "Arrow"),
                .product(name: "Hummingbird", package: "hummingbird"),
            ]
        ),
    ]
)