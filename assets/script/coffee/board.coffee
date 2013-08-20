Scrabble = @Scrabble
{Util, Score, WordFinder} = Scrabble
Board = Scrabble.Board = class

  constructor: ({size, words, grid}) ->
    if Util.isMatrixQuadratic grid then size = Util.sizeMatrix grid
    else grid = undefined

    unless Board.isValidSize size then throw new Error "Grid size not given"
    grid or= Util.generateGrid size
    wordList = Util.wordList {size, words}
    @score = new Score grid: grid, dictionary: wordList

    @size = -> size
    @isWord = (str) ->
      WordFinder.isWord word: str, dictionary: wordList
    @move = (swapCoordinates) -> @score.moveScore swapCoordinates

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

Board.isValidSize = (size) ->
  if (not size) or size < 0 then false else true
