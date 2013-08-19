Scrabble = @Scrabble or= {}

Util = Scrabble.Util = class

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
      Scrabble.Tile.randomLetter()

Util.printGrid = (grid) ->
  rows = @matrix grid
  rowStrings = (' ' + row.join(' | ') for row in rows)
  rowStrings.join '\n'

Util.matrix = (grid) ->
  for x in [0...grid.length]
    for y in [0...grid[x].length]
      grid[x][y]

Util.wordList = ({size, words}) ->
  (word for word in words when Scrabble.TileFinder.MIN_TILE_LENGTH <= word.length <= size)

Util.isMatrixQuadratic = (matrix) ->
  return false unless matrix
  for row in matrix
    return false unless matrix.length is row.length
  true

Util.sizeMatrix = (matrix) ->
  if @isMatrixQuadratic matrix then matrix.length else undefined

Util.isValidSwapCoordinates = ({x1, y1, x2, y2, range}) ->
  movingHorizontaly = Math.abs x2 - x1
  movingVerticaly   = Math.abs y2 - y1
  isMovingDiagonaly = (movingHorizontaly > 0) and (movingVerticaly > 0)
  isValid = if isMovingDiagonaly then false else (movingHorizontaly is 1) or (movingVerticaly is 1)
  if isValid and range?
    @inRange({ x: x1, y: y1, range }) and @inRange({ x: x2, y: y2, range })
  else
    isValid

Util.createSwapCoordinate = ({x: x1, y: y1}, {x: x2, y: y2}) ->
  {x1, y1, x2, y2}

Util.createSwipeCoordinate = ({x, y}, {x: xi, y: yi}) ->
  x += xi if xi?
  y += yi if yi?
  {x, y: y}


Message = Util.Message = class
  constructor: ({@player, @score}) ->

  playerInfo: ->
    name:        @player?.name?()
    numberWords: @score?.newWords?.length
    points:      @score?.points
    words:       @score?.newWords or []

  points: ->
    player = @playerInfo()
    message  = "#{player.name} formed the following #{player.numberWords} word(s): "
    message += "#{player.words}. "
    message += "Earning #{player.points} points"

  @tile: (tile) ->
    {x, y} = tile?.coordinate or {}
    "Tile (#{x}, #{y}) selected"
