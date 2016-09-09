# Straw

String manipulation esolang

## Usage

    straw.rb <file>

## Reference

Straw have 2 stacks, the first is initialized with an empty string and the second with `Hello, World!`.

### Commands

|Command|Description|
|:-:|:-:|
|`(`|String literal, ends on `)`. Parenthesis are nestable, and \` is the escape character.|
|`+`|Pop `b`, pop `a` and push `a` and `b` concatened.|
|`*`|Pop `b`, pop `a` and push length of `b` times `a`.|
|`&`|Pop a string and evaluate it.|
|`:`|Duplicate the top of the stack.|
|`;`|Drop the top of the stack.|
|`,`|Swap the two items on the top of the stack.|
|`~`|Toggle the current stack.|
|`-`|Pop an item from the inactive stack and push it on the active one.|
|`>`|Pop a string and print it. This don't print a trailing nweline.|
|`<`|Read a string from STDIN and push it.|
|`?`|Have a 1/2 chance of skipping the next instruction.|
|`'`|Pop `condition`, `if` and `else` and execute `if` if the length of `condition` is >0, `else` otheriwse.|
|`=`|Pop two items, push `Y` if the two items are equal, an empty string otherwise.|
|`!`|Pop two items, push `Y` if the two items are not equal, an empty string otherwise.|
|`{`|Pop an item and push its first character.|
|`}`|Pop an item and push it without the first character.|
|`/`|Pop `replacement`, `regex` and `string` and push `string` with all matching occurences of `regex` replaced by `replacement`.|
|`.`|Pop a regex and a string and push `Y` if the regex match the string, an empty string otherwise.|
|`]`|Pop `var` and a value, set the variable `var` to the value.|
|`[`|Pop `var` and a push the variable `var`.|

Any character that isn't a command is pushed on the current stack.

## Examples

* `hello_world.str`: A hello world
* `truth_machine.str`: A truth machine
