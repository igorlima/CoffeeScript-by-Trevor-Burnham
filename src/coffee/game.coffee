Game = @Game = class

  constructor: (options={}) ->
    {size, words} = options
    throw "Grid size not given" unless Game.isValidSize size
    grid = Util.generateGrid size
    wordList = Util.wordList {size, words}

    @size = -> size
    @isWord = (str) ->
      WordFinder.isWord word: str, dictionary: wordList

    @str = -> Util.printGrid grid
    @matrix = -> Util.matrix grid

    @set = (coordinate) ->
      {x, y, value} = coordinate
      Util.setCoordinate { coordinates: grid, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Util.getCoordinate { coordinates: grid, x, y }

  inRange: (num) ->
    Util.inRange value: num, range: @size()

Game.isValidSize = (size) ->
  if (not size) or size < 0 then false else true
