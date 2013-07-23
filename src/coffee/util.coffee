Util = @Util = class
MIN_WORD_LENGTH = Util.MIN_WORD_LENGTH = 2

Util.isInteger = (num) ->
  num is Math.round num

Util.inRange = (params) ->
  {value, size, x, y} = params
  if value?
    (@isInteger value) and 0 <= value < size
  else if x? and y?
    (@inRange {value: x, size}) and (@inRange {value: y, size})

Util.setCoordinate = (params) ->
  {coordinates, range, x, y, value} = params
  coordinates[x] ||= []

  if @inRange( value: x, size: range ) and @inRange( value: y, size: range )
    coordinates[x][y] = value
  else
    coordinates[x][y] = undefined

  !!coordinates[x][y]

Util.getCoordinate = (params) ->
  {coordinates, x, y} = params
  coordinates[x][y]

Util.generateGrid = (size) ->
  for x in [0...size]
    for y in [0...size]
      Tile.randomLetter()

Util.printGrid = (grid) ->
  rows = for x in [0...grid.length]
    for y in [0...grid[x].length]
      grid[x][y]
  rowStrings = (' ' + row.join(' | ') for row in rows)
  rowStrings.join '\n'

Util.wordList = (size) ->
  (word for word in Words when word.length <= size)

Util.word = (params, funcDirectionLetter) ->
  {grid, range, x: col, y: row} = params
  word = ""
  for i in [0...range]
    letter = funcDirectionLetter i
    word += letter if letter?
  word if word.length >= range

Util.wordVertical = (params) ->
  {grid, range, x: col, y: row} = params
  @word params, (i) -> grid[row+i]?[col]

Util.wordHorizontal = (params) ->
  {grid, range, x: col, y: row} = params
  @word params, (i) -> grid[row]?[col+i]

Util.wordDiagonal_upperLeft_to_lowerRight = (params) ->
  {grid, range, x: col, y: row} = params
  @word params, (i) -> grid[row+i]?[col+i]

Util.wordDiagonal_lowerLeft_to_upperRight = (params) ->
  {grid, range, x: col, y: row} = params
  @word params, (i) -> grid[row-i]?[col+i]

Util.words = (params, function_to_match_word) ->
  {grid, range, x, y} = params
  words = []
  for word_length in [MIN_WORD_LENGTH..range]
    for offset in [0...word_length]
      word = function_to_match_word word_length, offset
      words.push word if word? and not (word in words)
  words

Util.verticalWords = (params) ->
  {grid, range, x, y} = params
  Util.words params, (word_length, offset) ->
    Util.wordVertical {grid, x, y: y - offset, range: word_length}
