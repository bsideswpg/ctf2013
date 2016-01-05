This is somewhat obfuscated Haskell code.
Obfuscated in the sense that it makes use of a lot of Haskell syntax, including:
- List comprehensions
- Tuples and lists
- Mapping
- The '$' operator
- Lambdas

It takes the first argument on the command line and scrambles it. If it does not match
the stored scrambled value, it is rejected.

The scrambling operation does the following:
- Converts the string to an array of integers based on their ordinal value
- Reverses the array of integers
- Builds a list of two-tuples from the array of integers (using a list comprehension)
  - Each two-tuple consists of (x^3, x^2) if x is even, otherwise (x, x^2)
- The list of two-tuples is converted to a list of lists (using a lambda)
  - Each member list is 2 elements long and contains the elements of the corrosponding two-tuple
- This new list-of-lists is transposed

We effectively end up with two lists (two big lists that are members of a list)
The first list is each character of the string taken to the power of 3, or left alone.
The second list is each character of the string taken to the second power.
Both lists are reversed.

This scrambling can be undone with the following Haskell function:

    undo x = reverse $ map chr $ map ceiling $ map sqrt x

Pseudo-code:
- Find the square root of each element in the list
- Take the integer part of each element
- Convert each element to a character (forming a string automatically)
- Reverse the string

Doing so yields the key: `high_func7ioning_hack3rs`

Possible ways to make this problem harder:
- Using algabraic data types
- Using monads, somehow
- Using some kind of cryptographically-secure computation
