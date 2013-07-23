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
