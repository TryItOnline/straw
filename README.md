# Straw

String manipulation esolang

## Usage

    straw.rb <file> [-u]

The `-u` flag is to directly read the file in UTF-8, without CP437 decoding it.

## Reference

Straw have 3 stacks:

* Two main stacks (the first is initialized with an empty string and the second with `Hello, World!`)
* One temporary stack

Straw use a modified CP437 encoding (FF is `…`).

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
|`"`|Pop a string and reverse it.|
|`/`|Pop `replacement`, `regex` and `string` and push `string` with all matching occurences of `regex` replaced by `replacement`.|
|`.`|Pop a regex and a string and push `Y` if the regex match the string, an empty string otherwise.|
|`]`|Pop `var` and a value, set the variable `var` to the value.|
|`[`|Pop `var` and a push the variable `var`.|
|`#`|Pop a decimal string, convert it to unary and push it.|
|`$`|Pop a string and push it length in decimal.|
|`%`|Pop a string, enclose it in parentheses and push it.|
|`@`|See the source code for a description.|
|`⌠`|Pop `a` and `b`, drop length of `a` characters on `b` and push `b`.|
|`⌡`|Pop `a` and `b`, take length of `a` characters on `b` and push `b`.|
|`|`|Pop `a` and `b`, split `b` with `a` and push a string pushing all splitted portions when evaluated.|
|`¡`|Get the depth of the stack.|
|`≤`|Pop a string of length n and push the n-th element of the stack (0 = most deep element).|
|`≥`|Pop a string of length n and push the n-th element of the stack (0 = least deep element).|
|`÷`|Pop `a` and `b` and push `b` / `a` (unary arithmetic).|
|`¥`|Pop `a` and `b` and push `b` mod `a` (unary arithmetic).|
|`æ`|Pop a character and push its CP437 ordinal.|
|`Æ`|Pop a number and push the CP437 character associated.|
|`ñ`|Pop an item and push it on the temporary stack.|
|`Ñ`|Pop an item on the temporary stack and push it on the main stack.|
|`≈`|Swap the current stack and the temporary one.|
|`σ`|Clear the temporary stack.|
|`¢`|Pop a list of list and a string, and for each element in the list, replace the first element (regex) by the second in the string.|
|`«`|Pop a string, sum the CP437 codepoints of each character in the string and push an unary number.|
|`»`|Pop a string and push it length encoded in CP437 codepoints.|
|`_`|Print the stack.|

Any character that isn't a command is pushed on the current stack.

## Examples

* `hello_world.str`: A hello world
* `truth_machine.str`: A truth machine
* `quine.str`: A quine
