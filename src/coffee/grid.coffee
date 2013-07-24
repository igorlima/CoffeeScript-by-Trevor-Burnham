@Grid = class

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    coordinates = Util.generateGrid size
    @set = (coordinate) ->
      {x, y, value} = coordinate
      Util.setCoordinate { coordinates, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Util.getCoordinate { coordinates, x, y }

    wordList = Util.wordList size
    @isWord = (str) ->
      WordFinder.isWord word: str, dictionary: wordList

    @str = -> Util.printGrid coordinates
    @matrix = -> Util.matrix coordinates

  inRange: (num) ->
    Util.inRange value: num, size: @size()
