Scrabble = @Scrabble
{TileFinder} = Scrabble

WordFinder = Scrabble.WordFinder = class
  @isWord: ({word, dictionary}) ->
    word in dictionary

  @all = ({grid, dictionary, range, x, y}) ->
    all_tiles = TileFinder.all {grid, dictionary, range, x, y}
    tile for tile in all_tiles when @isWord word: tile, dictionary: dictionary
