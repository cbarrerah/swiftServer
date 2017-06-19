// swift-tools-version:3.1

// sudo apt-get install openssl libssl-dev uuid-dev


import PackageDescription

let package = Package(
    name: "swiftserver",
    dependencies: [
    //.Package(url: "https://github.com/JustHTTP/Just.git", majorVersion: 0, minor: 5)
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7)
        ,.Package(url: "https://github.com/IBM-Swift/Kitura-Request.git", majorVersion: 0)
        //,   .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1, 0, 0)..<Version(3, .max, .max))

    ]
)
