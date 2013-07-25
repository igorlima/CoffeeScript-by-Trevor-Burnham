Scrabble = @Scrabble or= {}

TileFinder = Scrabble.TileFinder = class
MIN_TILE_LENGTH = TileFinder.MIN_TILE_LENGTH = 2

findOne = ({grid, range, x: col, y: row}, funcDirectionLetter) ->
  tile = ""
  for i in [0...range]
    letter = funcDirectionLetter i
    tile += letter if letter?
  tile if tile.length is range

findMany = ({grid, range, x, y}, function_to_match_tile) ->
  tiles = []
  for tile_length in [MIN_TILE_LENGTH..range]
    for offset in [0...tile_length]
      tile = function_to_match_tile tile_length, offset
      tiles.push tile if tile? and not (tile in tiles)
  tiles

TileFinder.verticalOne = ({grid, range, x: col, y: row}) ->
  params = {grid, range, x: col, y: row}
  findOne params, (i) -> grid[row+i]?[col]

TileFinder.horizontalOne = ({grid, range, x: col, y: row}) ->
  params = {grid, range, x: col, y: row}
  findOne params, (i) -> grid[row]?[col+i]

TileFinder.diagonalOne_upperLeft_to_lowerRight = ({grid, range, x: col, y: row}) ->
  params = {grid, range, x: col, y: row}
  findOne params, (i) -> grid[row+i]?[col+i]

TileFinder.diagonalOne_lowerLeft_to_upperRight = ({grid, range, x: col, y: row}) ->
  params = {grid, range, x: col, y: row}
  findOne params, (i) -> grid[row-i]?[col+i]

TileFinder.verticalTiles = ({grid, range, x, y}) ->
  params = {grid, range, x, y}
  findMany params, (tile_length, offset) ->
    TileFinder.verticalOne {grid, x, y: y - offset, range: tile_length}

TileFinder.horizontalTiles = ({grid, range, x, y}) ->
  params = {grid, range, x, y}
  findMany params, (tile_length, offset) ->
    TileFinder.horizontalOne {grid, x: x - offset, y, range: tile_length}

TileFinder.diagonalTiles_upperLeft_to_lowerRight = ({grid, range, x, y}) ->
  params = {grid, range, x, y}
  findMany params, (tile_length, offset) ->
    TileFinder.diagonalOne_upperLeft_to_lowerRight {grid, x: x - offset, y: y - offset, range: tile_length}

TileFinder.diagonalTiles_lowerLeft_to_upperRight = ({grid, range, x, y}) ->
  params = {grid, range, x, y}
  findMany params, (tile_length, offset) ->
    TileFinder.diagonalOne_lowerLeft_to_upperRight {grid, x: x - offset, y: y + offset, range: tile_length}

TileFinder.all = ({grid, range, x, y}) ->
  allTiles = []
  for finderTiles in [@verticalTiles, @horizontalTiles, @diagonalTiles_upperLeft_to_lowerRight, @diagonalTiles_lowerLeft_to_upperRight]
    tiles = finderTiles {grid, range, x, y}
    for tile in tiles
      allTiles.push tile unless tile in allTiles
  allTiles
