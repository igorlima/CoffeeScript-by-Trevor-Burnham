@Grid = class

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    coordinates = []
    coordinates[row] = [] for row in [0...size]
    @set = (coordinate) ->
      {x, y, value} = coordinate
      if @inRange(x) and @inRange(y) then coordinates[x][y] = value
      else coordinates[x][y] = undefined

      !!coordinates[x][y]

    @get = (coordinate) ->
      {x, y} = coordinate
      coordinates[x][y]

    wordList = (word for word in Words when word.length <= size)
    @isWord = (str) ->
      str in wordList

  inRange: (num) ->
    (@isInteger num) and 0 <= num < @size()

  isInteger: (num) ->
    num is Math.round num
