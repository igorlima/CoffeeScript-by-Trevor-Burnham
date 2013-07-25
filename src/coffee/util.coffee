Util = @Util = class

Util.isInteger = (num) ->
  num is Math.round num

Util.inRange = ({value, range, x, y}) ->
  if value?
    (@isInteger value) and 0 <= value < range
  else if x? and y?
    (@inRange {value: x, range}) and (@inRange {value: y, range})

Util.setCoordinate = ({coordinates, range, x, y, value}) ->
  coordinates[x] ||= []

  if @inRange({ value: x, range }) and @inRange({ value: y, range })
    coordinates[x][y] = value
  else
    coordinates[x][y] = undefined

  !!coordinates[x][y]

Util.getCoordinate = ({coordinates, x, y}) ->
  coordinates[x][y]

Util.generateGrid = (size) ->
  for x in [0...size]
    for y in [0...size]
      Tile.randomLetter()

Util.printGrid = (grid) ->
  rows = @matrix grid
  rowStrings = (' ' + row.join(' | ') for row in rows)
  rowStrings.join '\n'

Util.matrix = (grid) ->
  for x in [0...grid.length]
    for y in [0...grid[x].length]
      grid[x][y]

Util.wordList = ({size, words}) ->
  (word for word in words when TileFinder.MIN_TILE_LENGTH <= word.length <= size)

Util.isMatrixQuadratic = (matrix) ->
  return false unless matrix
  for row in matrix
    return false unless matrix.length is row.length
  true

Util.sizeMatrix = (matrix) ->
  if @isMatrixQuadratic matrix then matrix.length else undefined

Util.isValidSwapCoordinates = ({x1, y1, x2, y2, range}) ->
  isMovingHorizontaly = Math.abs( x2 - x1 ) is 1
  isMovingVerticaly = Math.abs( y2 - y1 ) is 1
  isMovingDiagonaly = isMovingHorizontaly and isMovingVerticaly
  isValid = if isMovingDiagonaly then false else isMovingHorizontaly or isMovingVerticaly
  if isValid and range?
    @inRange( x: x1, y: y1, size: range ) and @inRange( x: x2, y: y2, size: range )
  else
    isValid
