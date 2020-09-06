# Password

A Ruby gem to generate a password.

## Installation

* Add to Gemfile: `gem "password", git: "git@github.com:andrewjtait/password.git"`.
* And then run: `bundle install`.

## Instructions

```rb
require "password"

Password.generate
```

### Options

* `length` (default: 15) set the length of the password.
* `lowercase` (default: random) set how many lowercase characters to include in the password.
* `uppercase` (default: random) set how many uppercase characters to include in the password.
* `numbers` (default: random) set how many number characters to include in the password.
* `special` (default: random) set how many special characters to include in the password.

### Examples

```rb
Password.generate(length: 20)
Password.generate(lowercase: 10, special: 5)
```

## Testing

To run all tests, execute the following:

```
rake test
```