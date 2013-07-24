@Game = class

  constructor: (options={}) ->
    {size, words} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    grid = Util.generateGrid size
    @set = (coordinate) ->
      {x, y, value} = coordinate
      Util.setCoordinate { coordinates: grid, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Util.getCoordinate { coordinates: grid, x, y }

    wordList = Util.wordList {size, words}
    @isWord = (str) ->
      WordFinder.isWord word: str, dictionary: wordList

    @str = -> Util.printGrid grid
    @matrix = -> Util.matrix grid

  inRange: (num) ->
    Util.inRange value: num, size: @size()
