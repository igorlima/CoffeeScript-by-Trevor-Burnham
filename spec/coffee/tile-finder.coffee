describe "TileFinder class", ->
  grid = [
    ['B', 'D', 'A', 'A']
    ['D', 'O', 'G', 'S']
    ['A', 'E', 'S', 'A']
    ['S', 'S', 'A', 'S']
  ]

  it "a vertical tile from (x:1, y:0) with length 2 sould be 'DO'", ->
    tile = TileFinder.verticalOne grid: grid, range: 2, x: 1, y: 0
    expect( tile ).toBe 'DO'

  it "a vertical tile from (x:1, y:3) with length 2 sould be 'undefined', because the tile 'S' is less than length 2", ->
    tile = TileFinder.verticalOne grid: grid, range: 2, x: 1, y: 3
    expect( tile ).not.toBeDefined()

  it "a horizontal tile from (x:0, y:1) with length 3 sould be 'DOG'", ->
    tile = TileFinder.horizontalOne grid: grid, range: 3, x: 0, y: 1
    expect( tile ).toBe 'DOG'

  it "a diagonal tile upper-left to lower-right from (x:0, y:0) with length 4 sould be 'BOSS'", ->
    tile = TileFinder.diagonalOne_upperLeft_to_lowerRight grid: grid, range: 4, x: 0, y: 0
    expect( tile ).toBe 'BOSS'

  it "a diagonaly tile lower-left to upper-right from (x:0, y:3) with length 4 sould be 'SEGA'", ->
    tile = TileFinder.diagonalOne_lowerLeft_to_upperRight grid: grid, range: 4, x: 0, y: 3
    expect( tile ).toBe 'SEGA'

  it "a list of vertical tiles from (x: 1, y:0) should contains 'DO', 'DOE' and 'DOES'", ->
    tiles = TileFinder.verticalTiles grid: grid, range: 4, x: 1, y: 0
    expect( tiles ).toContain "DO"
    expect( tiles ).toContain "DOE"
    expect( tiles ).toContain "DOES"

  it "a list of vertical tiles from (x:1, y:1) should contains 'DO', 'DOE' and 'DOES'", ->
    tiles = TileFinder.verticalTiles grid: grid, range: 4, x: 1, y: 1
    expect( tiles ).toContain "DO"
    expect( tiles ).toContain "DOE"
    expect( tiles ).toContain "DOES"

  it "a list of horizontal tiles from (x: 0, y:1) should contains 'DO', 'DOG' and 'DOGS'", ->
    tiles = TileFinder.horizontalTiles grid: grid, range: 4, x: 0, y: 1
    expect( tiles ).toContain "DO"
    expect( tiles ).toContain "DOG"
    expect( tiles ).toContain "DOGS"

  it "a list of horizontal tiles from (x: 0, y:1) should contains 'DO', 'DOG' and 'DOGS'", ->
    tiles = TileFinder.horizontalTiles grid: grid, range: 4, x: 1, y: 1
    expect( tiles ).toContain "DO"
    expect( tiles ).toContain "DOG"
    expect( tiles ).toContain "DOGS"

  it "a list of diagnonal tiles upper-left to lower-right from (x: 0, y:0) should contains 'BOSS'", ->
    tiles = TileFinder.diagonalTiles_upperLeft_to_lowerRight grid: grid, range: 4, x: 0, y: 0
    expect( tiles ).toContain "BOSS"

  it "a list of diagnonal tiles upper-left to lower-right from (x: 1, y:1) should contains 'BOSS'", ->
    tiles = TileFinder.diagonalTiles_upperLeft_to_lowerRight grid: grid, range: 4, x: 1, y: 1
    expect( tiles ).toContain "BOSS"

  it "a list of diagnonal tiles lower-left to upper-right from (x: 0, y:3) should contains 'SEGA'", ->
    tiles = TileFinder.diagonalTiles_lowerLeft_to_upperRight grid: grid, range: 4, x: 0, y: 3
    expect( tiles ).toContain "SEGA"

  it "a list of diagnonal tiles lower-left to upper-right from (x: 1, y:2) should contains 'SEGA'", ->
    tiles = TileFinder.diagonalTiles_lowerLeft_to_upperRight grid: grid, range: 4, x: 1, y: 2
    expect( tiles ).toContain "SEGA"

  it "a list of all tiles from (x: 1, y:1) should contains 'DOES', 'BOSS' and 'DOGS'", ->
    tiles = TileFinder.all grid: grid, range: 4, x: 1, y: 1
    expect( tiles ).toContain "DOES"
    expect( tiles ).toContain "BOSS"
    expect( tiles ).toContain "DOGS"
