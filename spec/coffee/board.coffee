Board = Scrabble.Board

describe "Board class", ->

  describe "a generic board", ->
    generic_board = new Board size: 4, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']

    it "an exception will be raised if a 'words' property is not given", ->
      expect( -> new Board size: 2 ).toThrow()

    it "the undefined should NOT be a valid size", ->
      expect( Board.isValidSize() ).toBe false

    it "an exception will be raised if a size property is not given", ->
      expect( -> new Board() ).toThrow()

    it "the number 0 should NOT be a valid size", ->
      expect( Board.isValidSize 0 ).toBe false

    it "an exception will be raised if a size is 0", ->
      expect( -> new Board size: 0 ).toThrow()

    it "the number -1 should NOT be a valid size, because this number is less than 0", ->
      expect( Board.isValidSize -1 ).toBe false

    it "an exception will be raised if a size is less than 0", ->
      expect( -> new Board size: -1 ).toThrow()

    it "the number 4 should be a valid size, because it is greater than 0", ->
      expect( Board.isValidSize 4 ).toBe true

    it "4 should NOT be in range if the board has a grid with size 4", ->
      expect( generic_board.inRange 4 ).toBe false

    it "3 should be in range if the board has a grid with size 4", ->
      expect( generic_board.inRange 3 ).toBe true

    it "3.1 should NOT be in range, because it's NOT an integer", ->
      expect( generic_board.inRange 3.1 ).toBe false

    it "the word 'DOES' should be a word", ->
      expect( generic_board.isWord 'DOES' ).toBe true

    it "the word 'THINKING' should NOT be a word from a board that the grid has a size 4", ->
      expect( generic_board.isWord 'THINKING' ).toBe false

    it "the printing of grid should be defined", ->
      expect( generic_board.str() ).toBeDefined()

    it "the printing of grid should have 16 letter in a grid 4x4", ->
      printing = generic_board.str()
      letters = printing.match /[A-Z]/g
      expect( letters.length ).toBe 16

    it "the matrix of board should have 4 rows and 4 columns in a grid 4x4", ->
      matrix = generic_board.matrix()
      expect( matrix.length ).toBe 4
      expect( matrix[0].length ).toBe 4
      expect( matrix[1].length ).toBe 4
      expect( matrix[2].length ).toBe 4
      expect( matrix[3].length ).toBe 4

    it "coordinates (2,3) should be set", ->
      expect(generic_board.set x: 2, y: 3, value: 'a').toBe true
      expect(generic_board.get x: 2, y: 3).toBe 'a'

  describe "Using a given grid instead of a randomic one", ->
    board_with_a_given_matrix_not_quadratic = new Board size: 4, words: ['DO', 'GET', 'AS'], grid: [['D', 'A']]
    board_with_a_given_grid = new Board
      size: 4
      words: ['DOES', 'DO', 'DID', 'GET', 'AS']
      grid: [
        ['D', 'A']
        ['S', 'O']
      ]

    it "when a grid is given, it should be the given one", ->
      matrix = board_with_a_given_grid.matrix()
      expect( matrix[0] ).toEqual ['D', 'A']
      expect( matrix[1] ).toEqual ['S', 'O']

    it "when a grid is given, the size should be the same as the given one", ->
      expect( board_with_a_given_grid.size() ).toBe 2

    it "if the given grid is NOT quadratic, it should have the size given", ->
      expect( board_with_a_given_matrix_not_quadratic.size() ).toBe 4

    it "if the given grid is NOT quadratic, it should have the dimension of the size given", ->
      printing = board_with_a_given_matrix_not_quadratic.str()
      letters = printing.match /[A-Z]/g
      expect( letters.length ).toBe 16

  describe "5x5 project", ->
    board = undefined

    beforeEach ->
      board = new Board
        words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
        grid: [
          ['A', 'A', 'A', 'A', 'A']
          ['X', 'A', 'I', 'O', 'A']
          ['Z', 'C', 'D', 'D', 'G']
          ['Y', 'A', 'D', 'E', 'A']
          ['M', 'O', 'V', 'S', 'T']
        ]

    it "should be a size 5", ->
      expect(board.size()).toBe 5

    it "moving from (x: 3, y: 3) to (x: 4, y: 3) SHOULD have the word 'GET' as a new word", ->
      {scoreMove, newWords} = board.move x1: 3, y1: 3, x2: 4, y2: 3
      expect( newWords ).toContain 'GET'

    it "moving from (x: 3, y: 3) to (x: 3, y: 4) SHOULD have the following grid
        A | A | A | A | A
        X | A | I | O | A
        Z | C | D | D | G
        Y | A | D | S | A
        M | O | V | E | T
      ", ->
      board.move x1: 3, y1: 3, x2: 3, y2: 4
      matrix = board.matrix()
      expect( matrix[0] ).toEqual ['A', 'A', 'A', 'A', 'A']
      expect( matrix[1] ).toEqual ['X', 'A', 'I', 'O', 'A']
      expect( matrix[2] ).toEqual ['Z', 'C', 'D', 'D', 'G']
      expect( matrix[3] ).toEqual ['Y', 'A', 'D', 'S', 'A']
      expect( matrix[4] ).toEqual ['M', 'O', 'V', 'E', 'T']
