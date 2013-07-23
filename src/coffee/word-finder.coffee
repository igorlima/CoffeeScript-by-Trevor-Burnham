WordFinder = @WordFinder = class
MIN_WORD_LENGTH = WordFinder.MIN_WORD_LENGTH = 2

findOne = (params, funcDirectionLetter) ->
  {grid, range, x: col, y: row} = params
  word = ""
  for i in [0...range]
    letter = funcDirectionLetter i
    word += letter if letter?
  word if word.length is range

findMany = (params, function_to_match_word) ->
  {grid, range, x, y} = params
  words = []
  for word_length in [MIN_WORD_LENGTH..range]
    for offset in [0...word_length]
      word = function_to_match_word word_length, offset
      words.push word if word? and not (word in words)
  words

WordFinder.verticalOne = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row+i]?[col]

WordFinder.horizontalOne = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row]?[col+i]

WordFinder.diagonalOne_upperLeft_to_lowerRight = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row+i]?[col+i]

WordFinder.diagonalOne_lowerLeft_to_upperRight = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row-i]?[col+i]

WordFinder.verticalWords = (params) ->
  {grid, range, x, y} = params
  findMany params, (word_length, offset) ->
    WordFinder.verticalOne {grid, x, y: y - offset, range: word_length}

WordFinder.horizontalWords = (params) ->
  {grid, range, x, y} = params
  findMany params, (word_length, offset) ->
    WordFinder.horizontalOne {grid, x: x - offset, y, range: word_length}

WordFinder.diagonalWords_upperLeft_to_lowerRight = (params) ->
  {grid, range, x, y} = params
  findMany params, (word_length, offset) ->
    WordFinder.diagonalOne_upperLeft_to_lowerRight {grid, x: x - offset, y: y - offset, range: word_length}

WordFinder.diagonalWords_lowerLeft_to_upperRight = (params) ->
  {grid, range, x, y} = params
  findMany params, (word_length, offset) ->
    WordFinder.diagonalOne_lowerLeft_to_upperRight {grid, x: x - offset, y: y + offset, range: word_length}

WordFinder.all = (params) ->
  allWords = []
  for finderWords in [@verticalWords, @horizontalWords, @diagonalWords_upperLeft_to_lowerRight, @diagonalWords_lowerLeft_to_upperRight]
    words = finderWords params
    for word in words
      allWords.push word unless word in allWords
  allWords
