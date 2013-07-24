# Each letter has the same point value as in Scrabble
VALUES =
  A: 1, B: 3, C: 3, D: 2, E: 1,  F: 4, G: 2, H: 4, I: 1, J: 8, K: 5, L: 1
  M: 3, N: 1, O: 1, P: 3, Q: 10, R: 1, S: 1, T: 1, U: 1, V: 4, W: 4, X: 8
  Y: 4, Z: 10

Score = @Score = class
  constructor: (options={}) ->
    {grid, dictionary} = options

    @printGrid = -> Util.printGrid grid
    @matrix = -> Util.matrix grid

    @move = (swapCoordinates) -> Score.move {grid, swapCoordinates}

    @scoreWord = (word) ->
      if word in dictionary then Score.scoreWord word else 0

    @words = ->
      [words, SIZE] = [[], grid.length]
      for x in [0...SIZE]
        for y in [0...SIZE]
          words_on_xy = WordFinder.all {grid, dictionary, x, y, range: SIZE}
          words.push word for word in words_on_xy when word not in words
      words

Score.move = (params) ->
  {grid, swapCoordinates: {x1: col1, y1: row1, x2: col2, y2: row2} } = params
  [firstLetter, secondLetter] = [grid[row1][col1], grid[row2][col2]]
  [grid[row1][col1], grid[row2][col2]] = [secondLetter, firstLetter]
  grid

Score.scoreWord = (word) ->
  score = 0
  score += VALUES[letter] for letter in word
  score

Score.scoreWords = (words) ->
  [score, multiplier] = [0, words.length]
  score += @scoreWord word for word in words
  score * multiplier

Score.newWords = (params) ->
  {before: words_before, after: words_after} = params
  new_word for new_word in words_after when new_word not in words_before
