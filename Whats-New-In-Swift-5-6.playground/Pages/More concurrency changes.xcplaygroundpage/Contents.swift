/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# More concurrency changes

Swift 5.5 added a lot of features around concurrency, and 5.6 continues the process of refining those features to make them safer and more consistent, while also working towards bigger, breaking changes coming in Swift 6.

The biggest change is [SE-0337](https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md), which aims to provide a roadmap towards full, strict concurrency checking for our code. This is designed to be incremental: you can import whole modules using `@preconcurrency` to tell Swift the module was created without modern concurrency in mind; or you can mark individual classes, structs, properties, methods and more as `@preconcurrency` to be more selective.

In the short term this makes it significantly easier to migrate larger projects to modern concurrency.

Another area that’s changing is the use of actors, because as a result of [SE-0327](https://github.com/apple/swift-evolution/blob/main/proposals/0327-actor-initializers.md) Swift 5.6 now issues a warning if you attempt to instantiate a `@MainActor` property using `@StateObject` like this:
*/
import SwiftUI

@MainActor class Settings: ObservableObject { }
    
struct OldContentView: View {
    @StateObject private var settings = Settings()
    
    var body: some View {
        Text("Hello, world!")
    }
}
/*:
This warning will be upgraded to an error in Swift 6, so you should be prepared to move away from this code and use this instead:
*/
struct NewContentView: View {
    @StateObject private var settings: Settings
    
    init() {
        _settings = StateObject(wrappedValue: Settings())
    }
    
    var body: some View {
        Text("Hello, world!")
    }
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/