describe "TileFinder class", ->
  grid = [
    ['B', 'D', 'A', 'A']
    ['D', 'O', 'G', 'S']
    ['A', 'E', 'S', 'A']
    ['S', 'S', 'A', 'S']
  ]

  it "a vertical word from (x:1, y:0) with length 2 sould be 'DO'", ->
    word = TileFinder.verticalOne grid: grid, range: 2, x: 1, y: 0
    expect( word ).toBe 'DO'

  it "a vertical word from (x:1, y:3) with length 2 sould be 'undefined', because the word 'S' is less than length 2", ->
    word = TileFinder.verticalOne grid: grid, range: 2, x: 1, y: 3
    expect( word ).not.toBeDefined()

  it "a horizontal word from (x:0, y:1) with length 3 sould be 'DOG'", ->
    word = TileFinder.horizontalOne grid: grid, range: 3, x: 0, y: 1
    expect( word ).toBe 'DOG'

  it "a diagonal word upper-left to lower-right from (x:0, y:0) with length 4 sould be 'BOSS'", ->
    word = TileFinder.diagonalOne_upperLeft_to_lowerRight grid: grid, range: 4, x: 0, y: 0
    expect( word ).toBe 'BOSS'

  it "a diagonaly word lower-left to upper-right from (x:0, y:3) with length 4 sould be 'SEGA'", ->
    word = TileFinder.diagonalOne_lowerLeft_to_upperRight grid: grid, range: 4, x: 0, y: 3
    expect( word ).toBe 'SEGA'

  it "a list of vertical words from (x: 1, y:0) should contains 'DO', 'DOE' and 'DOES'", ->
    words = TileFinder.verticalWords grid: grid, range: 4, x: 1, y: 0
    expect( words ).toContain "DO"
    expect( words ).toContain "DOE"
    expect( words ).toContain "DOES"

  it "a list of vertical words from (x:1, y:1) should contains 'DO', 'DOE' and 'DOES'", ->
    words = TileFinder.verticalWords grid: grid, range: 4, x: 1, y: 1
    expect( words ).toContain "DO"
    expect( words ).toContain "DOE"
    expect( words ).toContain "DOES"

  it "a list of horizontal words from (x: 0, y:1) should contains 'DO', 'DOG' and 'DOGS'", ->
    words = TileFinder.horizontalWords grid: grid, range: 4, x: 0, y: 1
    expect( words ).toContain "DO"
    expect( words ).toContain "DOG"
    expect( words ).toContain "DOGS"

  it "a list of horizontal words from (x: 0, y:1) should contains 'DO', 'DOG' and 'DOGS'", ->
    words = TileFinder.horizontalWords grid: grid, range: 4, x: 1, y: 1
    expect( words ).toContain "DO"
    expect( words ).toContain "DOG"
    expect( words ).toContain "DOGS"

  it "a list of diagnonal words upper-left to lower-right from (x: 0, y:0) should contains 'BOSS'", ->
    words = TileFinder.diagonalWords_upperLeft_to_lowerRight grid: grid, range: 4, x: 0, y: 0
    expect( words ).toContain "BOSS"

  it "a list of diagnonal words upper-left to lower-right from (x: 1, y:1) should contains 'BOSS'", ->
    words = TileFinder.diagonalWords_upperLeft_to_lowerRight grid: grid, range: 4, x: 1, y: 1
    expect( words ).toContain "BOSS"

  it "a list of diagnonal words lower-left to upper-right from (x: 0, y:3) should contains 'SEGA'", ->
    words = TileFinder.diagonalWords_lowerLeft_to_upperRight grid: grid, range: 4, x: 0, y: 3
    expect( words ).toContain "SEGA"

  it "a list of diagnonal words lower-left to upper-right from (x: 1, y:2) should contains 'SEGA'", ->
    words = TileFinder.diagonalWords_lowerLeft_to_upperRight grid: grid, range: 4, x: 1, y: 2
    expect( words ).toContain "SEGA"

  it "a list of all words from (x: 1, y:1) should contains 'DOES', 'BOSS' and 'DOGS'", ->
    words = TileFinder.all grid: grid, range: 4, x: 1, y: 1
    expect( words ).toContain "DOES"
    expect( words ).toContain "BOSS"
    expect( words ).toContain "DOGS"
