Scrabble = @Scrabble
{Util, WordFinder} = Scrabble

# Each letter has the same point value as in Scrabble
VALUES =
  A: 1, B: 3, C: 3, D: 2, E: 1,  F: 4, G: 2, H: 4, I: 1, J: 8, K: 5, L: 1
  M: 3, N: 1, O: 1, P: 3, Q: 10, R: 1, S: 1, T: 1, U: 1, V: 4, W: 4, X: 8
  Y: 4, Z: 10

Score = Scrabble.Score = class
  constructor: ({grid, dictionary}) ->

    @printGrid = -> Util.printGrid grid
    @matrix = -> Util.matrix grid

    @moveScore = (swapCoordinates) ->
      Score.moveScore {grid, dictionary, swapCoordinates}

    @scoreWord = (word) ->
      if word in dictionary then Score.scoreWord word else 0

    @words = -> Score.words {grid, dictionary}

Score.words = ({grid, dictionary}) ->
  [words, SIZE] = [[], grid.length]
  for x in [0...SIZE]
    for y in [0...SIZE]
      words_on_xy = WordFinder.all {grid, dictionary, x, y, range: SIZE}
      words.push word for word in words_on_xy when word not in words
  words

Score.move = ({grid, swapCoordinates: {x1: col1, y1: row1, x2: col2, y2: row2} }) ->
  range = Util.sizeMatrix grid
  isValidMove = Util.isValidSwapCoordinates {x1: col1, y1: row1, x2: col2, y2: row2, range}
  if range? and isValidMove
    [grid[row2][col2], grid[row1][col1]] = [grid[row1][col1], grid[row2][col2]]
    true
  else
    false

Score.moveScore = ({grid, dictionary, swapCoordinates}) ->
  words_before_moving = @words {grid, dictionary}
  if @move {grid, swapCoordinates}
    words_after_moving = @words {grid, dictionary}
    new_words = @newWords before: words_before_moving, after: words_after_moving
    {points: @scoreWords(new_words), newWords: new_words}

Score.scoreWord = (word) ->
  score = 0
  score += VALUES[letter] for letter in word
  score

Score.scoreWords = (words) ->
  [score, multiplier] = [0, words.length]
  score += @scoreWord word for word in words
  score * multiplier

Score.newWords = ({before: words_before, after: words_after}) ->
  new_word for new_word in words_after when new_word not in words_before
