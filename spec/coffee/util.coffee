describe "Util class", ->

  it "3 should be an integer", ->
    expect( Util.isInteger 3 ).toBe true
  
  it "1.1 should NOT be an integer", ->
    expect( Util.isInteger 1.1 ).toBe false

  it "3 should be in range if the size is 4", ->
    expect( Util.inRange value: 3, size: 4 ).toBe true

  it "4 should NOT be in range if the size is 4", ->
    expect( Util.inRange value: 4, size: 4 ).toBe false

  it "(3,2) should be in range if the size is 4", ->
    expect( Util.inRange x: 3, y: 2, size: 4 ).toBe true

  it "coordinate (2,3) should NOT be set, if the coordenate is not in range", ->
    options = coordinates: [], range: 3, x: 2, y: 3, value: 'a'
    expect( Util.setCoordinate options ).toBe false

  it "coordinate (2,3) should be set", ->
    options = coordinates: [], range: 5, x: 2, y: 3, value: 'a'
    expect( Util.setCoordinate options ).toBe true

  it "coordinate (2,3) should be 'a', if [[],[],['','','','a']]", ->
    options = coordinates: [[],[],['','','','a']], x: 2, y: 3
    expect( Util.getCoordinate options ).toBe 'a'

  it "the generate grid should create a grid 2x2 if the size is 2", ->
    grid = Util.generateGrid 2
    expect( grid.length ).toBe 2
    expect( grid[0].length ).toBe 2

  it "the generate grid should create a grid with letters from the alphabet", ->
    grid = Util.generateGrid 2
    expect( Tile.alphabet() ).toContain grid[0][0]
    expect( Tile.alphabet() ).toContain grid[0][1]
    expect( Tile.alphabet() ).toContain grid[1][0]
    expect( Tile.alphabet() ).toContain grid[1][1]

  it "the printing of grid 4x4 method should be
        A | A | A | A
        A | A | B | A
        A | C | A | A
        A | A | A | A
      ", ->

    grid_string_rows = (Util.printGrid [
      ['A', 'A', 'A', 'A']
      ['A', 'A', 'B', 'A']
      ['A', 'C', 'A', 'A']
      ['A', 'A', 'A', 'A']
    ]).split '\n'

    expect( grid_string_rows[0] ).toMatch "A [|] A [|] A [|] A"
    expect( grid_string_rows[1] ).toMatch "A [|] A [|] B [|] A"
    expect( grid_string_rows[2] ).toMatch "A [|] C [|] A [|] A"
    expect( grid_string_rows[3] ).toMatch "A [|] A [|] A [|] A"

  it "the word list with 2 letters should NOT contains the word 'DOES', because it has 4 letters instead", ->
    wordList = Util.wordList 2
    expect( wordList ).not.toContain 'DOES'

  it "the word list with 2 letters should contains the word 'DO'", ->
    wordList = Util.wordList 2
    expect( wordList ).toContain 'DO'

  describe "Words through the following grid ", ->
    grid = [
      ['B', 'D', 'A', 'A']
      ['D', 'O', 'G', 'S']
      ['A', 'E', 'S', 'A']
      ['S', 'S', 'A', 'S']
    ]

    it "the word verticaly from (x:1, y:0) with length 2 sould be 'DO'", ->
      word = Util.wordVertical grid: grid, range: 2, x: 1, y: 0
      expect( word ).toBe 'DO'

    it "the word verticaly from (x:1, y:3) with length 2 sould be 'undefined', because the word 'S' is less than length 2", ->
      word = Util.wordVertical grid: grid, range: 2, x: 1, y: 3
      expect( word ).not.toBeDefined()

    it "the word horizontaly from (x:0, y:1) with length 3 sould be 'DOG'", ->
      word = Util.wordHorizontal grid: grid, range: 3, x: 0, y: 1
      expect( word ).toBe 'DOG'

    it "the word diagonaly upper-left to lower-right from (x:0, y:0) with length 4 sould be 'BOSS'", ->
      word = Util.wordDiagonal_upperLeft_to_lowerRight grid: grid, range: 4, x: 0, y: 0
      expect( word ).toBe 'BOSS'

    it "the word diagonaly lower-left to upper-right from (x:0, y:3) with length 4 sould be 'SEGA'", ->
      word = Util.wordDiagonal_lowerLeft_to_upperRight grid: grid, range: 4, x: 0, y: 3
      expect( word ).toBe 'SEGA'

    it "the list of vertical words from (x: 1, y:0) should contains 'DO', 'DOE' and 'DOES'", ->
      words = Util.verticalWords grid: grid, range: 4, x: 1, y: 0
      expect( words ).toContain "DO"
      expect( words ).toContain "DOE"
      expect( words ).toContain "DOES"

    it "the list of vertical words from (x:1, y:1) should contains 'DO', 'DOE' and 'DOES'", ->
      words = Util.verticalWords grid: grid, range: 4, x: 1, y: 1
      expect( words ).toContain "DO"
      expect( words ).toContain "DOE"
      expect( words ).toContain "DOES"
