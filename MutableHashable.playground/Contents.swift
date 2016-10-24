/*:

 # Mutating Hashables in Collections
 
 When you have a mutable object that is hashable, if mutating the object affects 
 its hash value, that can cause problems when it is contained inside a collection.
 
*/

//: A simple mutable hashable class to demonstrate with
class MutableInt : Hashable, Equatable {
    var value:Int
    
    init( _ value:Int ) {
        self.value = value
    }
    
    var hashValue: Int {
        return value.hashValue
    }
    
    static func == ( lhs: MutableInt, rhs: MutableInt ) -> Bool {
        return lhs.value == rhs.value
    }
}

//: Some sample instances
let one = MutableInt(1)
let mutating = MutableInt(1)
let two = MutableInt(2)

//: Let's make sure the comparisons work as expected
one == mutating
two != one
two != mutating

//: And it works inside a set...
let oneSet:Set = [one]
oneSet.contains(one)
oneSet.contains(mutating)

//: Ok, let's try putting an instance in a set and then modifying it...
let mutSet:Set = [mutating]
mutSet.contains(one)
mutating.value = 2

//: Does the modified instance work with Equatable?
one != mutating
two == mutating

//: How does the set react?
mutSet.contains(one) // as expected
mutSet.contains(two) // hmm... not good
mutSet.contains(mutating) // really bad
