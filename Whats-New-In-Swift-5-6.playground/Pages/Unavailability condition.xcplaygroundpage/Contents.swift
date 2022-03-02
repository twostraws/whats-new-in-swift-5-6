/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Unavailability condition

[SE-0290](https://github.com/apple/swift-evolution/blob/main/proposals/0290-negative-availability.md) introduces an inverted form of `#available` called `#unavailable`, which will run some code if an availability check fails.

This is going to be particularly useful in places where you were previously using `#available` with an empty true block because you only wanted to run code if a specific operating system was *unavailable*. So, rather than writing code like this:
*/
if #available(iOS 15, *) { } else {
    // Code to make iOS 14 and earlier work correctly
}
/*:
We can now write this:
*/
if #unavailable(iOS 15) {
    // Code to make iOS 14 and earlier work correctly
}
/*:
This problem wasn’t just theoretical – using an empty `#available` block was a [fairly](https://github.com/signalapp/Signal-iOS/blob/fb2e0d785081d4f4b2d2f568f1f2a4f8e94ee5a2/Signal/src/ViewControllers/ConversationView/ConversationViewLayout.swift#L890) [common](https://github.com/videolan/vlc-ios/blob/82e93d7b3e1ce607bacfa61bd4938f36a816be74/SharedSources/Store%20Integration/StoreViewController.swift#L48) [workaround](https://github.com/ProtonMail/ios-mail/blob/bad1e950430f3ae1d893dc8e4ad5f4833ecfbfe2/ProtonMail/ProtonMail/AppDelegate.swift#L226), particularly in the transition to the scene-based UIKit APIs in iOS 13.

Apart from their flipped behavior, one key difference between `#available` and `#unavailable` is the platform wildcard, `*`. This is required with `#available` to allow for potential future platforms, which meant that writing `if #available(iOS 15, *)` would mark some code as being available on iOS versions 15 or later, or all other platforms – macOS, tvOS, watchOS, and any future unknown platforms.

With `#unavailable`, this behavior no longer makes sense: would writing `if #unavailable(iOS 15, *)` mean “the following code should be run on iOS 14 and earlier,” or should it also include macOS, tvOS, watchOS, Linux, and more, where iOS 15 is also unavailable? To avoid this ambiguity, the platform wildcard is *not* allowed with `#unavailable`: only platforms you specifically list are considered for the test.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/