Util = @Util = class

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
  rows = @matrix grid
  rowStrings = (' ' + row.join(' | ') for row in rows)
  rowStrings.join '\n'

Util.matrix = (grid) ->
  for x in [0...grid.length]
    for y in [0...grid[x].length]
      grid[x][y]

Util.wordList = (params) ->
  {size, words} = params
  (word for word in words when word.length <= size)

Util.isMatrixQuadratic = (matrix) ->
  for row in matrix
    return false unless matrix.length is row.length
  true

Util.sizeMatrix = (matrix) ->
  if @isMatrixQuadratic matrix then matrix.length else undefined

Util.isValidSwapCoordinates = (params) ->
  {x1, y1, x2, y2, range} = params
  isMovingHorizontaly = Math.abs( x2 - x1 ) is 1
  isMovingVerticaly = Math.abs( y2 - y1 ) is 1
  isMovingDiagonaly = isMovingHorizontaly and isMovingVerticaly
  isValid = if isMovingDiagonaly then false else isMovingHorizontaly or isMovingVerticaly
  if isValid and range?
    @inRange( x: x1, y: y1, size: range ) and @inRange( x: x2, y: y2, size: range )
  else
    isValid
