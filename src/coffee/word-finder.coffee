Scrabble = @Scrabble or= {}

WordFinder = Scrabble.WordFinder = class

WordFinder.isWord = ({word, dictionary}) ->
  word in dictionary

WordFinder.all = ({grid, dictionary, range, x, y}) ->
  all_tiles = Scrabble.TileFinder.all {grid, dictionary, range, x, y}
  tile for tile in all_tiles when @isWord word: tile, dictionary: dictionary
