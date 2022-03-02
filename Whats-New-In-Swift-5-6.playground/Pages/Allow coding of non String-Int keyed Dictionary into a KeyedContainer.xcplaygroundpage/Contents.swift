/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Allow coding of non `String`/`Int` keyed `Dictionary` into a `KeyedContainer`

[SE-0320](https://github.com/apple/swift-evolution/blob/main/proposals/0320-codingkeyrepresentable.md) introduces a new `CodingKeyRepresentable` protocol that allows dictionaries with keys that aren’t a plain `String` or `Int` to be encoded as keyed containers rather than unkeyed containers. 

To understand why this is important, you first need to see the behavior without `CodingKeyRepresentable` in place. As an example, this old code uses enum cases for keys in a dictionary, then encodes it to JSON and prints out the resulting string:
*/
import Foundation

enum OldSettings: String, Codable {
    case name
    case twitter
}

let oldDict: [OldSettings: String] = [.name: "Paul", .twitter: "@twostraws"]
let oldData = try JSONEncoder().encode(oldDict)
print(String(decoding: oldData, as: UTF8.self))
/*:
Although the enum has a `String` raw value, because the dictionary keys aren’t `String` or `Int` the resulting string will be **["twitter","@twostraws","name","Paul"]** – four separate string values, rather than something that is obviously key/value pairs. Swift is smart enough to recognize this in decoding, and will match alternating strings inside each pair to the original enum keys and string values, but this isn’t helpful if you want to send the JSON to a server.

The new `CodingKeyRepresentable` resolves this, allowing the new dictionary keys to be written correctly. However, as this changes the way your `Codable` JSON is written, you must explicitly add `CodingKeyRepresentable` conformance to get the new behavior, like this:
*/
enum NewSettings: String, Codable, CodingKeyRepresentable {
    case name
    case twitter
}

let newDict: [NewSettings: String] = [.name: "Paul", .twitter: "@twostraws"]
let newData = try! JSONEncoder().encode(newDict)
print(String(decoding: newData, as: UTF8.self))
/*:
That will print **{"twitter":"@twostraws","name":"Paul”}**, which is much more useful outside of Swift.

If you’re using custom structs as your keys, you can also conform to `CodingKeyRepresentable` and provide your own methods for converting your data into a string.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/