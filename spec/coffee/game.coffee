
describe "Game class", ->

  describe "a generic game", ->
    generic_game = new Game size: 4, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']

    it "an exception will be raised if a 'words' property is not given", ->
      expect( -> new Game size: 2 ).toThrow()

    it "the undefined should NOT be a valid size", ->
      expect( Game.isValidSize() ).toBe false

    it "an exception will be raised if a size property is not given", ->
      expect( -> new Game() ).toThrow()

    it "the number 0 should NOT be a valid size", ->
      expect( Game.isValidSize 0 ).toBe false

    it "an exception will be raised if a size is 0", ->
      expect( -> new Game size: 0 ).toThrow()

    it "the number -1 should NOT be a valid size, because this number is less than 0", ->
      expect( Game.isValidSize -1 ).toBe false

    it "an exception will be raised if a size is less than 0", ->
      expect( -> new Game size: -1 ).toThrow()

    it "the number 4 should be a valid size, because it is greater than 0", ->
      expect( Game.isValidSize 4 ).toBe true

    it "4 should NOT be in range if the game has a grid with size 4", ->
      expect( generic_game.inRange 4 ).toBe false

    it "3 should be in range if the game has a grid with size 4", ->
      expect( generic_game.inRange 3 ).toBe true

    it "3.1 should NOT be in range, because it's NOT an integer", ->
      expect( generic_game.inRange 3.1 ).toBe false

    it "the word 'DOES' should be a word", ->
      expect( generic_game.isWord 'DOES' ).toBe true

    it "the word 'THINKING' should NOT be a word from a game that the grid has a size 4", ->
      expect( generic_game.isWord 'THINKING' ).toBe false

    it "the printing of grid should be defined", ->
      expect( generic_game.str() ).toBeDefined()

    it "the printing of grid should have 16 letter in a grid 4x4", ->
      printing = generic_game.str()
      letters = printing.match /[A-Z]/g
      expect( letters.length ).toBe 16

    it "the matrix of game should have 4 rows and 4 columns in a grid 4x4", ->
      matrix = generic_game.matrix()
      expect( matrix.length ).toBe 4
      expect( matrix[0].length ).toBe 4
      expect( matrix[1].length ).toBe 4
      expect( matrix[2].length ).toBe 4
      expect( matrix[3].length ).toBe 4

  describe "Using a given grid instead of a randomic one", ->
    game_with_a_given_matrix_not_quadratic = new Game size: 4, words: ['DO', 'GET', 'AS'], grid: [['D', 'A']]
    game_with_a_given_grid = new Game
      size: 4
      words: ['DOES', 'DO', 'DID', 'GET', 'AS']
      grid: [
        ['D', 'A']
        ['S', 'O']
      ]

    it "when a grid is given, it should be the given one", ->
      matrix = game_with_a_given_grid.matrix()
      expect( matrix[0] ).toEqual ['D', 'A']
      expect( matrix[1] ).toEqual ['S', 'O']

    it "when a grid is given, the size should be the same as the given one", ->
      expect( game_with_a_given_grid.size() ).toBe 2

    it "if the given grid is NOT quadratic, it should have the size given", ->
      expect( game_with_a_given_matrix_not_quadratic.size() ).toBe 4

    it "if the given grid is NOT quadratic, it should have the dimension of the size given", ->
      printing = game_with_a_given_matrix_not_quadratic.str()
      letters = printing.match /[A-Z]/g
      expect( letters.length ).toBe 16

  describe "5x5 project", ->
    game = new Game size: 5, words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']

    it "should be a size 5", ->
      expect(game.size()).toBe 5

    it "coordinates (2,3) should be set", ->
      expect(game.set x: 2, y: 3, value: 'a').toBe true
      expect(game.get x: 2, y: 3).toBe 'a'
