Util = @Util = class

Util.isInteger = (num) ->
  num is Math.round num

Util.inRange = (params) ->
  {value, size} = params
  (@isInteger value) and 0 <= value < size

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

Util.generateGrid = (options) ->
  {size} = options
  for x in [0...size]
    for y in [0...size]
      Tile.randomLetter()

Util.printGrid = (grid) ->
  rows = for x in [0...grid.length]
    for y in [0...grid[x].length]
      grid[y][x]
  rowStrings = (' ' + row.join(' | ') for row in rows)
  rowStrings.join '\n'
