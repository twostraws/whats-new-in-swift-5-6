/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Type placeholders

[SE-0315](https://github.com/apple/swift-evolution/blob/main/proposals/0315-placeholder-types.md) introduces the concept of type placeholders, which allow us to explicitly specify only some parts of a value’s type so that the remainder can be filled in using type inference.

In practice, this means writing `_` as your type in any place you want Swift to use type inference, meaning that these three lines of code are the same:
*/
let score1 = 5
let score2: Int = 5
let score3: _ = 5
/*:
In those trivial examples type placeholders don’t add anything, but they *are* useful when the compiler is able to correctly infer part of a type but not all. For example, if you were creating a dictionary of student names and all the exam results they had this year, you might write this:
*/
var results1 = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": [],
]
/*:
Swift will infer that to be a dictionary with strings as keys, and an array of `Any` as values – almost certainly not what you want. You could specify the entire type explicitly, like this:
*/
var results2: [String: [Int]] = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": [],
]
/*:
However, type placeholders allow you to write `_` in place of the parts you want the compiler to infer – it’s a way for us to explicitly say “this part should use type inference”, alongside places where we want an exact type of our choosing.

So, we could also write this:
*/
var results3: [_: [Int]] = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": [],
]
/*:
As you can see, the `_` there is an explicit request for type inference, but we still have the opportunity to specify the exact array type.

**Tip:** Type placeholders can be optional too – use `_?` to have Swift infer your type as optional.

Types placeholders do *not* affect the way we write function signatures: you must still provide their parameter and return types in full. However, I have found that type placeholders do still serve a purpose for when you’re busy experimenting with a prototype: telling the compiler you want it to infer some type often prompts Xcode to offer a Fix-it to complete the code for you.

For example, you might write code to create a player like this:
*/
struct Player<T: Numeric> {
    var name: String
    var score: T
}
    
func createPlayer() -> _ {
    Player(name: "Anonymous", score: 0)
}
/*:
That fails to specify a return type for `createPlayer()`, which will cause a compiler error. However, as we’ve asked Swift to infer the type, the error in Xcode will offer a Fix-it to replace `_` with `Player<Int>` – you can imagine that saving a fair amount of hassle when dealing with more complex types.

Think of type placeholders as a way of simplifying long type annotations: you can replace all the less relevant or boilerplate parts with underscores, leaving the important parts spelled out to help make your code more readable.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/