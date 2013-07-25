Scrablle = @Scrablle or= {}

Game = Scrablle.Game = class

  constructor: ({size, words, grid}) ->
    if Scrablle.Util.isMatrixQuadratic grid then size = Scrablle.Util.sizeMatrix grid
    else grid = undefined

    throw "Grid size not given" unless Game.isValidSize size
    grid or= Scrablle.Util.generateGrid size
    wordList = Scrablle.Util.wordList {size, words}
    score = new Scrablle.Score grid: grid, dictionary: words

    @size = -> size
    @isWord = (str) ->
      WordFinder.isWord word: str, dictionary: wordList
    @move = (swapCoordinates) -> score.moveScore swapCoordinates

    @str = -> Scrablle.Util.printGrid grid
    @matrix = -> Scrablle.Util.matrix grid

    @set = (coordinate) ->
      {x, y, value} = coordinate
      Scrablle.Util.setCoordinate { coordinates: grid, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Scrablle.Util.getCoordinate { coordinates: grid, x, y }

  inRange: (num) ->
    Scrablle.Util.inRange value: num, range: @size()

Game.isValidSize = (size) ->
  if (not size) or size < 0 then false else true
