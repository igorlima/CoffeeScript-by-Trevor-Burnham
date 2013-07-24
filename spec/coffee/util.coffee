describe "Util class", ->

  grid_for_printing = [
    ['A', 'A', 'A', 'A']
    ['A', 'A', 'B', 'A']
    ['A', 'C', 'A', 'A']
    ['A', 'A', 'A', 'A']
  ]

  grid_for_matrixing = [
    ['A', 'A', 'A', 'A']
    ['X', 'A', 'B', 'A']
    ['Z', 'C', 'A', 'A']
    ['Y', 'A', 'A', 'A']
  ]

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
    grid_string_rows = (Util.printGrid grid_for_printing).split '\n'
    expect( grid_string_rows[0] ).toMatch "A [|] A [|] A [|] A"
    expect( grid_string_rows[1] ).toMatch "A [|] A [|] B [|] A"
    expect( grid_string_rows[2] ).toMatch "A [|] C [|] A [|] A"
    expect( grid_string_rows[3] ).toMatch "A [|] A [|] A [|] A"

  it "the word list with 2 letters should NOT contains the word 'DOES', because it has 4 letters instead", ->
    wordList = Util.wordList size: 2, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
    expect( wordList ).not.toContain 'DOES'

  it "the word list with 2 letters should contains the word 'DO'", ->
    wordList = Util.wordList size: 2, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
    expect( wordList ).toContain 'DO'

  it "the matrix of following grid 4x4 method should be
        A | A | A | A
        X | A | B | A
        Z | C | A | A
        Y | A | A | A
      ", ->
    matrix = Util.matrix grid_for_matrixing
    expect( matrix[0] ).toEqual ['A', 'A', 'A', 'A']
    expect( matrix[1] ).toEqual ['X', 'A', 'B', 'A']
    expect( matrix[2] ).toEqual ['Z', 'C', 'A', 'A']
    expect( matrix[3] ).toEqual ['Y', 'A', 'A', 'A']

  it "the following matrix should be a matrix quadratic 4x4
        A | A | A | A
        X | A | B | A
        Z | C | A | A
        Y | A | A | A
      ", ->
    expect( Util.isMatrixQuadratic grid_for_matrixing ).toBe true

  it "the following matrix should NOT be a matrix quadratic
        A | A | A | A
        X | A | B | A
        Z | C | A
        Y | A | A | A
      because the rows does NOT 4 columns each one
      ", ->
    expect( Util.isMatrixQuadratic [
      ['A', 'A', 'A', 'A']
      ['X', 'A', 'B', 'A']
      ['Z', 'C', 'A']
      ['Y', 'A', 'A', 'A']
    ] ).toBe false

  it "the following matrix should have a size as 4
        A | A | A | A
        X | A | B | A
        Z | C | A | A
        Y | A | A | A
      ", ->
    expect( Util.sizeMatrix grid_for_matrixing ).toBe 4

  it "the following matrix should NOT have a size
        A | A | A | A
        X | A | B | A
        Z | C | A
        Y | A | A | A
      because this matrix is NOT a matrix quadratic
      ", ->
    expect( Util.sizeMatrix [
      ['A', 'A', 'A', 'A']
      ['X', 'A', 'B', 'A']
      ['Z', 'C', 'A']
      ['Y', 'A', 'A', 'A']
    ] ).not.toBeDefined()
