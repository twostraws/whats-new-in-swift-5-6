/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Introduce existential `any`

[SE-0335](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) introduces a new `any` keyword to mark existential types, and although that might sound esoteric please don’t skip ahead: this one is a big change, and is likely to break a lot of Swift code in future versions.

Protocols allow us to specify a set of requirements that conforming types must adhere to, such as methods they must implement. So, we often write code like this:
*/
protocol Vehicle {
    func travel(to destination: String)
}
    
struct Car: Vehicle {
    func travel(to destination: String) {
        print("I'm driving to \(destination)")
    }
}
    
let vehicle = Car()
vehicle.travel(to: "London")
/*:
It’s also possible to use protocols as generic type constraints in functions, meaning that we write code that can work with any kind of data that conforms to a particular protocol. For example, this will work with any kind of type that conforms to `Vehicle`:
*/
func travel<T: Vehicle>(to destinations: [String], using vehicle: T) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}
    
travel(to: ["London", "Amarillo"], using: vehicle)
/*:
When that code compiles, Swift can see we’re calling `travel()` with a `Car` instance and so it is able to create optimized code to call the `travel()` function directly – a process known as *static dispatch*.

All this matters because there is a second way to use protocols, and it looks very similar to the other code we’ve used so far:
*/
let vehicle2: Vehicle = Car()
vehicle2.travel(to: "Glasgow")
/*:
Here we are still creating a `Car` struct, but we’re storing it as a `Vehicle`. This isn’t just a simple matter of hiding the underlying information, but instead this `Vehicle` type is a whole other thing called an *existential type*: a new data type that is able to hold any value of any type that conforms to the `Vehicle` protocol.

**Important:** Existential types are different from opaque types that use the `some` keyword, e.g. `some View`, which must always represent one specific type that conforms to whatever constraints you specify.

We can use existential types with functions too, like this:
*/
func travel2(to destinations: [String], using vehicle: Vehicle) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}
/*:
That might look similar to the other `travel()` function, but as this one accepts any kind of `Vehicle` object Swift can no longer perform the same set of optimizations – it has to use a process called *dynamic dispatch*, which is less efficient than the static dispatch available in the generic equivalent.  So, Swift was in a position where both uses of protocols looked very similar, and actually the slower, existential version of our function was easier to write.

To resolve this problem, Swift 5.6 introduces a new `any` keyword for use with existential types, so that we’re explicitly acknowledging the impact of existentials in our code. In Swift 5.6 this new behavior is enabled and works, but in future Swift versions failing to use it will generate warnings, and from Swift 6 onwards the plan is to issue errors – you will be *required* to mark existential types using `any`.

So, you would write this:
*/
let vehicle3: any Vehicle = Car()
vehicle3.travel(to: "Glasgow")

func travel3(to destinations: [String], using vehicle: any Vehicle) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}
/*:
I know it took a lot of explanation to reach this conclusion, but hopefully it makes sense: when we use `Vehicle` as a conformance or a generic constraint we will carry on writing `Vehicle`, but when we use it as its own type we should start moving across to `any Vehicle`.

**This is a big breaking change in Swift.** Fortunately, like I said the Swift team are taking it slow – here’s what they said in the [acceptance decision](https://forums.swift.org/t/accepted-with-modifications-se-0335-introduce-existential-any/54504):

> “The goal is that that one can write code that compiles without warnings for the current Swift release and at least one major release prior, after which warnings can be introduced to guide users to the new syntax in existing language modes. Finally, the old syntax can be removed or repurposed only in a new major language version.”

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/