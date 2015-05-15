It's a fork from [lzrski/config-object][].

The goal is to put all reusable data manipulation logic here and use it internally in config-object.

Install
-------

```shell
npm install data-object
```

Usage
-----

Here's what you can do now:


```coffee-script
Data = require 'data-object'
data = new Data
  a:
    b: 1
    c:
      d: 2
      e: 'Elf'
    f: 'Ferret'

data.get 'a/c/e'  # Elf
data.get 'a/c'    # d: 2, e: Elf
data.bonus = 200
data.get 'bonus'  # 200
data.get number: 'a/c/d', animal: 'a/f' # number: 2, animal: 'Ferret'
```

ATM only most basic `get` works. More functionality is to come, including:

* No dependencies (esp. lodash)
* Drop-in replacement for most of config-object code

I will successively move config-object's features here. See [pending test cases][] for more todo items.

[pending test cases]:   test/index.coffee
[lzrski/config-object]: https://github.com/lzrski/config-object
