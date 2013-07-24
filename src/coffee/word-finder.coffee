WordFinder = @WordFinder = class

WordFinder.isWord = (params) ->
  {word, dictionary} = params
  word in dictionary

WordFinder.all = (params) ->
  {grid, dictionary, range, x, y} = params
  all_tiles = TileFinder.all params
  tile for tile in all_tiles when @isWord word: tile, dictionary: dictionary
