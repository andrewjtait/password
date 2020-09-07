# Notes

The following notes were taken during and after development of the gem.

## Randomisation

* I am using `rand` to generate random numbers, as well as `sample` to select random characters from an array. If I wanted to improve security and mitigate random number generator attacks I could instead rely on a library such as `SecureRandom`.
* I was mistakingly calling `sample` once per character set, which meant that characters could only be used once per password. Luckily I caught this through testing and updated the code to instead call `sample` once per character rather than by set. See [this commit](https://github.com/andrewjtait/password/commit/87cb545b807da42e85a830ab86473248799e87cb) for more detail.
* The module is generating character types in order of lowercase, uppercase, numbers and then special characters. Because of this it means that passwords are often [a-z] heavy, I added a [simple attempt to mitigate this](https://github.com/andrewjtait/password/commit/8c8a2dc3de88f1bcae46e854a9d7ad0b64337022) but I could refactor the code further to randomise the order in which the types of characters are generated.

## Tests

* I am not too familiar with minitest, as I normally work with rspec, so maybe there are utils I am not aware of that could improve the tests.
* I decided to change the approach of how I was testing the code part way through development. See [this commit](https://github.com/andrewjtait/password/commit/3d6f7af72c668072045e7f0f8bde2c6ea13d044f) for more detail.
* The module may be a good candidate for property-based testing using randomised generated examples. eg. for properties A, B and C we should expect the result to contain X, Y and Z. This would allow us to catch more edge cases without having to manually think up or write out test cases.

## Other

* I am using 15 as a default for the password length, I chose this arbitrarily. With further consideration there may be a more secure minimum length for a password or perhaps it would be better to randomise the length.
* The code is using a Singleton approach with `class << self`, this allows for private methods and more concise code such as being able to use instance variables. There are some potential issues with this though, such as thread safety due to shared state via instance variables. While this may not be an issue, [this commit](https://github.com/andrewjtait/password/commit/6ac1f742668f993bea38869b74d60b198c7552e2) refactors the code to remove the use of instance variables to ensure there are no problems. Alternative approaches include relying only on the module, changing the module to be a class which can be instantiated and use state properly, or using composition of multiple modules.
* Additional refactoring could be completed to further break methods down into single responsibilities. For example the `set_character_counts` method is also performing some validation, or I could break the module up into multiple modules and/or classes to distribute responsibilities.
* A future improvement could be to make the gem executable from the command line.
* The implementation is aware of the various character sets in use, a future improvement could be to refactor the character set configs into a single hash which the code could iterate over to generate the password. This would make it easier to add or remove character sets without having to change the implementation of the code. A possible tradeoff from this approach would be abstracting the `generate` method signature so it is unclear what arguments are accepted (as it would now read the arguments dynamically based on the config), but this could be mitigated through documentation.
