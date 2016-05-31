/*:
 # `NSDecimalNumber` and `unsignedIntegerValue`

 NSDecimalNumber can have surprising behaviour in some cases -- I encountered this when reading the
 unsigned integer value of an NSDecimalNumber which I was reading from a [KVC Collection Operator].

 [KVC Collection Operator]: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/CollectionOperators.html
*/

import Foundation

/*:
 ## What I Expected
 
 I'd expect that if you had an NSDecimalNumber representing a real number, and you ask for its unsignedIntegerValue,
 you would get an unsigned integer that is close to the real number, maybe `round()`ed or `floor()`ed. In some scenarios,
 this is exactly what happens.
*/
let floatNsdn = NSDecimalNumber(float:55.55)
print( "floatNsdn: \(floatNsdn)" )
print( "as unsigned int: \(floatNsdn.unsignedIntegerValue)" )

/*:
  ## What I Discovered
 
 Instead, what I discovered is that the average value I was expecting was being returned as zero. At first I thought
 that I'd messed up the KVC Collection Operator, but as soon as I started up the debugger, I could see the `NSDecimalNumber` 
 average value was fine, but that the `unsignedIntegerValue` conversion was not.
*/
let intArray = NSArray(array: [88,86,83,84,84,89,92,94,94,93,94,92,95,90]);
if let averageNsdn = intArray.valueForKeyPath("@avg.floatValue") {
    print( "averageNsdn: \(averageNsdn)" )
    print( "as unsigned int: \(averageNsdn.unsignedIntegerValue)" )
}

/*:
 ## Investigating
 
 After reading a little documentation, including a [StackOverflow post] and the [Subclassing Notes for NSNumber],
 I could see some people having the same problem. The Subclassing Notes make you wonder if they're warning you
 about scenarios like this, although I am inclined to believe it is a bug.
 
 Does NSDecimalNumber just not handle float to unsigned integer? We already know that's not true. Is it the number?
 
 [Subclassing Notes for NSNumber]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNumber_Class/#//apple_ref/occ/instp/NSNumber/
 [StackOverflow post]: http://stackoverflow.com/questions/25705511/nsdecimalnumber-integervalue-behaving-strangely-in-ios8
*/
let matchingFloatNsdn = NSDecimalNumber(float:89.857142857142857142857142857142857142)
print( "floatNsdn: \(matchingFloatNsdn)" )
print( "as unsigned int: \(matchingFloatNsdn.unsignedIntegerValue)" )

/*:
 ## Using String Initializer
 
 Of course, due to floating point representation, it's likely that the code above does not exactly reproduce 
 the number, and even their string representations are different.
*/
let longStringNsdn = NSDecimalNumber(string:"89.857142857142857142857142857142857142")
print( "longStringNsdn: \(longStringNsdn)" )
print( "as unsigned int: \(longStringNsdn.unsignedIntegerValue)" )

/*:
 ## Any String Initializer?
 
 What if it's just something to do with using the String initializer?
*/
let shortStringNsdn = NSDecimalNumber(string:"89.8571428571428")
print( "shortStringNsdn: \(shortStringNsdn)" )
print( "as unsigned int: \(shortStringNsdn.unsignedIntegerValue)" )

//: No, that worked ok.

/*:
 ## Long Mantissa?
 
 Is it just real numbers with long mantissas, that aren't easy to represent within the normal type space?
*/
 
let longIntegerStringNsdn = NSDecimalNumber(string: "89857142857142857142857142857142857142" )
print( "longIntegerStringNsdn: \(longIntegerStringNsdn)" )
print( "as unsigned int: \(longIntegerStringNsdn.unsignedIntegerValue)" )

//: No, the type overflowed, but it wasn't just a zero.

/*:
 I haven't figured out all the combinations that work and that don't. It seems safe to say that if you want 
 the `unsignedIntegerValue` of an `NSDecimalNumber`, you are going to have to some of the conversion yourself,
 (for instance `floor(nsdn.doubleValue)` )
*/
 