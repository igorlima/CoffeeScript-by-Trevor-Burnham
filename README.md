<a href="https://saucelabs.com/u/Scrabble">
  <img src="https://saucelabs.com/browser-matrix/Scrabble.svg" alt="Selenium Tests Status" />
</a>

CoffeeScript-by-Trevor-Burnham
==============================

Learning from a book named “CoffeeScript - Accelerated JavaScript Development by Trevor Burnham”

As its name suggests, 5x5 is played on a grid five tiles wide and five tiles high.
Each tile has a random letter on the grid, scoring points for all words formed
as a result of the swap (potentially, this can be four words at each of the two swapped
tiles: one running horizontally, one vertically, and two diagonally - only left-to-right
giagonals count).

Scoring is based on the Scrabble point value of the letters in the formed words,
with a multiplier for the number of distinct words formed. So, at the upper limit,
if eight words are formed in one move, then the point value of each is multiplied by
eight. Words that have already been used in the game don't count.


Syntax highlighting on Sublime Text
===================================

https://github.com/Xavura/CoffeeScript-Sublime-Plugin


## Snippets

- Use `TAB` to run a snippet after typing the trigger.
- Use `TAB` and `shift+TAB` to cycle forward/backward through fields.
- Use `ESC` to exit snippet mode.

### Snippet Triggers

**Comprehension**

  Array:  forin
  Object: forof
  Range:  fori (inclusive)
  Range:  forx (exclusive)

**Statements**

  If:        if
  Else:      el
  If Else:   ifel
  Else If:   elif
  Switch:    swi
  Ternary:   ter
  Try Catch: try
  Unless:    unl

**Classes**

  Class - cla

**Other**

  Function:      -
  Function:      = (bound)
  Interpolation: #
