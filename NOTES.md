# Notes

The following are notes taken during and after development of the gem.

## Priority

## Randomisation

## Tests

Since the generation of the password is random, it adds some complication to testing.

 * Using `srand` in the test makes the execution deterministic so the output is consistent.
 * The tests are currently asserting the exact value of the output. This is probably the easiest to write and read, however it makes the tests a bit brittle. For example a change in the code may result in all tests needing to be updated, even though the result is still valid. Instead I could refactor the tests to assert that the output includes what it should definetely have (eg. 5 lowercase characters and 5 numbers).

 ## Edge cases

 ## Other