describe "Util class", ->

  it "3 should be an integer", ->
    expect( Util.isInteger 3 ).toBe true
  
  it "1.1 should NOT be an integer", ->
    expect( Util.isInteger 1.1 ).toBe false

  it "3 should be in range if the size is 4", ->
    expect( Util.inRange value: 3, size: 4 ).toBe true

  it "4 should NOT be in range if the size is 4", ->
    expect( Util.inRange value: 4, size: 4 ).toBe false

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
