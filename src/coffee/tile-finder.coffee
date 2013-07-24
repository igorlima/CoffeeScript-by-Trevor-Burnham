TileFinder = @TileFinder = class
MIN_TILE_LENGTH = TileFinder.MIN_TILE_LENGTH = 2

findOne = (params, funcDirectionLetter) ->
  {grid, range, x: col, y: row} = params
  tile = ""
  for i in [0...range]
    letter = funcDirectionLetter i
    tile += letter if letter?
  tile if tile.length is range

findMany = (params, function_to_match_tile) ->
  {grid, range, x, y} = params
  tiles = []
  for tile_length in [MIN_TILE_LENGTH..range]
    for offset in [0...tile_length]
      tile = function_to_match_tile tile_length, offset
      tiles.push tile if tile? and not (tile in tiles)
  tiles

TileFinder.verticalOne = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row+i]?[col]

TileFinder.horizontalOne = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row]?[col+i]

TileFinder.diagonalOne_upperLeft_to_lowerRight = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row+i]?[col+i]

TileFinder.diagonalOne_lowerLeft_to_upperRight = (params) ->
  {grid, range, x: col, y: row} = params
  findOne params, (i) -> grid[row-i]?[col+i]

TileFinder.verticalTiles = (params) ->
  {grid, range, x, y} = params
  findMany params, (tile_length, offset) ->
    TileFinder.verticalOne {grid, x, y: y - offset, range: tile_length}

TileFinder.horizontalTiles = (params) ->
  {grid, range, x, y} = params
  findMany params, (tile_length, offset) ->
    TileFinder.horizontalOne {grid, x: x - offset, y, range: tile_length}

TileFinder.diagonalTiles_upperLeft_to_lowerRight = (params) ->
  {grid, range, x, y} = params
  findMany params, (tile_length, offset) ->
    TileFinder.diagonalOne_upperLeft_to_lowerRight {grid, x: x - offset, y: y - offset, range: tile_length}

TileFinder.diagonalTiles_lowerLeft_to_upperRight = (params) ->
  {grid, range, x, y} = params
  findMany params, (tile_length, offset) ->
    TileFinder.diagonalOne_lowerLeft_to_upperRight {grid, x: x - offset, y: y + offset, range: tile_length}

TileFinder.all = (params) ->
  allTiles = []
  for finderTiles in [@verticalTiles, @horizontalTiles, @diagonalTiles_upperLeft_to_lowerRight, @diagonalTiles_lowerLeft_to_upperRight]
    tiles = finderTiles params
    for tile in tiles
      allTiles.push tile unless tile in allTiles
  allTiles
