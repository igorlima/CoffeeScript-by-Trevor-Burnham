@Grid = class

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    coordinates = []
    @set = (coordinate) ->
      {x, y, value} = coordinate
      Util.setCoordinate { coordinates, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Util.getCoordinate { coordinates, x, y }

    wordList = (word for word in Words when word.length <= size)
    @isWord = (str) ->
      str in wordList

  inRange: (num) ->
    Util.inRange value: num, size: @size()
