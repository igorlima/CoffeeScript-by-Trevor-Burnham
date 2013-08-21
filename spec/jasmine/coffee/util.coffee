{Util, Tile, Player} = Scrabble

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

  it "the word list with 2 letters should NOT contains the word 'DOES', because it has 4 letters instead", ->
    wordList = Util.wordList size: 2, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
    expect( wordList ).not.toContain 'DOES'

  it "the word list with 2 letters should contains the word 'DO'", ->
    wordList = Util.wordList size: 2, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
    expect( wordList ).toContain 'DO'

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

  describe "a grid random 2x2", ->
    grid = undefined
    beforeEach ->
      grid = Util.generateGrid 2

    it "grid SHOULD have 2 lines", ->
      expect( grid.length ).toBe 2

    it "first line SHOULD have a length as 2", ->
      expect( grid[0].length ).toBe 2

    describe "letters on grid", ->

      it "tile (0, 0) SHOULD be a letter from the alphabet", ->
        expect( Tile.alphabet() ).toContain grid[0][0]

      it "tile (0, 1) SHOULD be a letter from the alphabet", ->
        expect( Tile.alphabet() ).toContain grid[0][1]

      it "tile (1, 0) SHOULD be a letter from the alphabet", ->
        expect( Tile.alphabet() ).toContain grid[1][0]

      it "tile (1, 1) SHOULD be a letter from the alphabet", ->
        expect( Tile.alphabet() ).toContain grid[1][1]

  describe "printing a grid 4x4
        A | A | A | A
        A | A | B | A
        A | C | A | A
        A | A | A | A
      ", ->
    grid_string_rows = undefined
    beforeEach ->
      grid_string_rows = (Util.printGrid grid_for_printing).split '\n'

    it "first line SHOULD be 'A | A | A | A'", ->
      expect( grid_string_rows[0] ).toMatch "A [|] A [|] A [|] A"

    it "second line SHOULD be 'A | A | B | A'", ->
      expect( grid_string_rows[1] ).toMatch "A [|] A [|] B [|] A"

    it "third line SHOULD be 'A | C | A | A'", ->
      expect( grid_string_rows[2] ).toMatch "A [|] C [|] A [|] A"

    it "forth line SHOULD be 'A | A | A | A'", ->
      expect( grid_string_rows[3] ).toMatch "A [|] A [|] A [|] A"

  describe "a matrix 4x4
        A | A | A | A
        X | A | B | A
        Z | C | A | A
        Y | A | A | A
      ", ->
    matrix = undefined
    beforeEach ->
      matrix = Util.matrix grid_for_matrixing

    it "first line SHOULD be ['A', 'A', 'A', 'A']", ->
      expect( matrix[0] ).toEqual ['A', 'A', 'A', 'A']

    it "second line SHOULD be ['X', 'A', 'B', 'A']", ->
      expect( matrix[1] ).toEqual ['X', 'A', 'B', 'A']

    it "third line SHOULD be ['Z', 'C', 'A', 'A']", ->
      expect( matrix[2] ).toEqual ['Z', 'C', 'A', 'A']

    it "forth line SHOULD be ['Y', 'A', 'A', 'A']", ->
      expect( matrix[3] ).toEqual ['Y', 'A', 'A', 'A']

  describe "minimum word size", ->
    wordList = undefined
    beforeEach ->
      wordList = Util.wordList size: 2, words: ['A', 'B', 'DOES', 'DO', 'DID', 'GET', 'MOVE']

    it "letter 'A' SHOULD not be on the list. The minimum word size should be 2.", ->
      expect( wordList ).not.toContain 'A'

    it "letter 'B' SHOULD not be on the list. The minimum word size should be 2.", ->
      expect( wordList ).not.toContain 'B'

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

    it "from (4, 0) to (2, 1) with range as 5 SHOULD not be a valid move", ->
      expect( Util.isValidSwapCoordinates x1: 4, y1: 0, x2: 2, y2: 1, range: 5 ).not.toBe true

  describe "creating a swap coordinate", ->

    it "{x:1, y:2} and {x:2, y:2} are given, then the swap coordinate should be {x1: 1, y1: 2, x2: 2, y2: 2}", ->
      swapCoordinate = Util.createSwapCoordinate {x:1, y:2}, {x:2, y:2}
      expect( swapCoordinate ).toEqual {x1: 1, y1: 2, x2: 2, y2: 2}

    it "{x:1, y:2} and {x:1, y:1} are given, then the swap coordinate should be {x1: 1, y1: 2, x2: 1, y2: 1}", ->
      swapCoordinate = Util.createSwapCoordinate {x:1, y:2}, {x:1, y:1}
      expect( swapCoordinate ).toEqual {x1: 1, y1: 2, x2: 1, y2: 1}

  describe "creating a swipe coordinate. It will increase (or decrease) the coordinate", ->

    it "{x:1, y:2} and {x:1} are given, then the swipe coordinate should be {x: 2, y: 2}", ->
      coordinate = Util.createSwipeCoordinate {x:1, y:2}, {x:1}
      expect(coordinate).toEqual {x:2, y:2}

    it "{x:1, y:2} and {x:-1} are given, then the swipe coordinate should be {x: 0, y: 2}", ->
      coordinate = Util.createSwipeCoordinate {x:1, y:2}, {x:-1}
      expect(coordinate).toEqual {x:0, y:2}

    it "{x:1, y:2} and {y:-1} are given, then the swipe coordinate should be {x: 1, y: 1}", ->
      coordinate = Util.createSwipeCoordinate {x:1, y:2}, {y:-1}
      expect(coordinate).toEqual {x:1, y:1}

  describe "setting message", ->
    message = undefined
    Message = Util.Message

    describe "not selected a tile", ->
      beforeEach ->
        player  = new Player name: 'Albert'
        message = Message.tile {player}

      it "SHOULD contain the name 'Albert'", ->
        expect( message ).toContain 'Albert'

      it "SHOULD contain 'select a tile'", ->
        expect( message ).toContain 'select a tile'

    describe "a selected tile", ->

      describe "tile (2, 1)", ->
        beforeEach ->
          player = new Player name: 'Player 1'
          tile = coordinate: {x: 2, y: 1}
          message = Message.tile {tile, player}

        it "message SHOULD contain the word 'selected'", ->
          expect( message ).toContain "selected"

        it "message SHOULD contain 'Tile (2, 1)'", ->
          expect( message ).toMatch /[Tt]ile [(]2, 1[)]/

        it "message SHOULD contain the player name 'Player 1'", ->
          expect( message ).toContain "Player 1"

        it "message SHOULD contain 'select a second tile'", ->
          expect( message ).toContain "select a second tile"

      describe "tile (1, 3)", ->
        beforeEach ->
          player = new Player name: 'Player 2'
          tile = coordinate: {x: 1, y: 3}
          message = Message.tile {tile, player}

        it "message SHOULD contain the word 'selected'", ->
          expect( message ).toContain "selected"

        it "message SHOULD contatin 'Tile (1, 3)'", ->
          expect( message ).toMatch /[Tt]ile [(]1, 3[)]/

        it "message SHOULD contain the player name 'Player 2'", ->
          expect( message ).toContain "Player 2"

    describe "a player John scored in 45 points with 3 words", ->
      message = undefined
      beforeEach ->
        player = new Player name: 'John'
        score = points: 45, newWords: ['OD', 'HID', 'HO']
        message = Message.points {player, score}

      it "message SHOULD contain '45 points'", ->
        expect( message ).toMatch /(.)*45(.)* points/

      it "message SHOULD contain the word 'OD'", ->
        expect( message ).toContain 'OD'

      it "message SHOULD contain the word 'HID'", ->
        expect( message ).toContain 'HID'

      it "message SHOULD contain the word 'HO'", ->
        expect( message ).toContain 'HO'

      it "message SHOULD contain '3 word(s)'", ->
        expect( message ).toContain '3 word(s)'

      it "message SHOULD contain the player name: John", ->
        expect( message ).toContain 'John'

    describe "a player Biel scored in 90 points with 4 words", ->
      message = undefined
      beforeEach ->
        player = new Player name: 'Biel'
        score = points: 90, newWords: ['DID', 'DONE', 'MOVE', 'DO']
        message = Message.points {player, score}

      it "message SHOULD contain '90 points'", ->
        expect( message ).toMatch /(.)*90(.)* points/

      it "message SHOULD contain the player name: Biel", ->
        expect( message ).toContain 'Biel'

      it "message SHOULD contain '4 word(s)'", ->
        expect( message ).toContain '4 word(s)'

      it "message SHOULD contain the word 'MOVE'", ->
        expect( message ).toContain 'MOVE'

      it "message SHOULD match with this pattern:
          <1. player name> formed the following <2. number of words> word(s):
          <3. list of words>
          Earning <4. number of points> points
          ", ->
        expect( message ).toMatch /Biel (.)+ 4 word(.)+ (.)*90(.)* points/
