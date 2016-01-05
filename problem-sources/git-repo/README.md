The repository has a number of commits. They are all just a file named
"dangle" with an monotonically-increasing number of a's.

There is a single blob that is dangling. It was inserted into the object database
manually with `git hash-object -w`.
This single dangling blob contains the text `the_genetic_opera`. This is the flag
for this challenge.

After the dangling blob was added, it was moved to the `.git/lost-found` directory
automatically after an invocation of `git fsck --lost-found`.

To find the dangling blob:
 `git fsck`
or
 Explore `.git/lost-found` (it will be the only object present)

To extract the contents of the dangling blob:
- `git cat-file -p <sha1>`
- Some sort of hardcore zlib magic on the file in `.git/lost-found`
