Scrabble = @Scrabble or= {}

Board = Scrabble.Board = class

  constructor: ({size, words, grid}) ->
    if Scrabble.Util.isMatrixQuadratic grid then size = Scrabble.Util.sizeMatrix grid
    else grid = undefined

    unless Board.isValidSize size then throw new Error "Grid size not given"
    grid or= Scrabble.Util.generateGrid size
    wordList = Scrabble.Util.wordList {size, words}
    @score = new Scrabble.Score grid: grid, dictionary: wordList

    @size = -> size
    @isWord = (str) ->
      Scrabble.WordFinder.isWord word: str, dictionary: wordList
    @move = (swapCoordinates) -> @score.moveScore swapCoordinates

    @str = -> Scrabble.Util.printGrid grid
    @matrix = -> Scrabble.Util.matrix grid

    @set = (coordinate) ->
      {x, y, value} = coordinate
      Scrabble.Util.setCoordinate { coordinates: grid, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Scrabble.Util.getCoordinate { coordinates: grid, x, y }

  inRange: (num) ->
    Scrabble.Util.inRange value: num, range: @size()

Board.isValidSize = (size) ->
  if (not size) or size < 0 then false else true
