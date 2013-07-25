{Util, Tile} = Scrablle

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

  it "3 should be in range if the range is 4", ->
    expect( Util.inRange value: 3, range: 4 ).toBe true

  it "4 should NOT be in range if the range is 4", ->
    expect( Util.inRange value: 4, range: 4 ).toBe false

  it "(3,2) should be in range if the range is 4", ->
    expect( Util.inRange x: 3, y: 2, range: 4 ).toBe true

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

  it "the minimum word size should be 2", ->
    wordList = Util.wordList size: 2, words: ['A', 'B', 'DOES', 'DO', 'DID', 'GET', 'MOVE']
    expect( wordList ).not.toContain 'A'
    expect( wordList ).not.toContain 'B'

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

  it "undefined should NOT be a matrix quadratic", ->
    expect( Util.isMatrixQuadratic() ).toBe false

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

  describe "valid swap coordinates (moving)", ->

    it "from (x: 0, y: 0) to (x: 0, y: 1) SHOULD be a valid move, because it's doing a lower vertical move", ->
      expect( Util.isValidSwapCoordinates x1: 0, y1: 0, x2: 0, y2: 1 ).toBe true

    it "from (x: 0, y: 1) to (x: 0, y: 0) SHOULD be a valid move, because it's doing a upper vertical move", ->
      expect( Util.isValidSwapCoordinates x1: 0, y1: 1, x2: 0, y2: 0 ).toBe true

    it "from (x: 0, y: 0) to (x: 1, y: 0) SHOULD be a valid move, because it's doing a right horizontal move", ->
      expect( Util.isValidSwapCoordinates x1: 0, y1: 0, x2: 1, y2: 0 ).toBe true

    it "from (x: 1, y: 0) to (x: 0, y: 0) SHOULD be a valid move, because it's doing a left horizontal move", ->
      expect( Util.isValidSwapCoordinates x1: 1, y1: 0, x2: 0, y2: 0 ).toBe true

    it "from (x: 0, y: 0) to (x: 1, y: 1) SHOULD NOT be a valid move, because it's moving diagonaly (upper left to lower right)", ->
      expect( Util.isValidSwapCoordinates x1: 0, y1: 0, x2: 1, y2: 1 ).toBe false

    it "from (x: 1, y: 1) to (x: 0, y: 0) SHOULD NOT be a valid move, because it's moving diagonaly (lower right to upper left)", ->
      expect( Util.isValidSwapCoordinates x1: 1, y1: 1, x2: 0, y2: 0 ).toBe false

    it "from (x: 0, y: 1) to (x: 1, y: 0) SHOULD NOT be a valid move, because it's moving diagonaly (lower left to upper right)", ->
      expect( Util.isValidSwapCoordinates x1: 0, y1: 1, x2: 1, y2: 0 ).toBe false

    it "from (x: 1, y: 0) to (x: 0, y: 1) SHOULD NOT be a valid move, because it's moving diagonaly (upper right to lower left)", ->
      expect( Util.isValidSwapCoordinates x1: 1, y1: 0, x2: 0, y2: 1 ).toBe false

    it "from (x: -1, y: 0) to (x: 0, y: 0) whith the range as 4 SHOULD NOT be a valid move, because it SHOULD validate if there is a negative coordinate", ->
      expect( Util.isValidSwapCoordinates x1: -1, y1: 0, x2: 0, y2: 0, range: 4 ).toBe false

    it "from (x: 1, y: 0) to (x: 0, y: 0) whith the range as 4 SHOULD be a valid move", ->
      expect( Util.isValidSwapCoordinates x1: 1, y1: 0, x2: 0, y2: 0, range: 4 ).toBe true
