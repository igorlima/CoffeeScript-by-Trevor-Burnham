{Game, Board} = Scrabble

describe "Game class", ->
  words = ['DOES', 'DO', 'DID', 'GET', 'MOVE']

  describe "Each instance of game", ->

    it "an exception should raise when instanciating the game without a list of word and without a board", ->
      expect( -> new Game() ).toThrow()

    it "the game should have a list of word", ->
      game = new Game words: words
      expect( game.words ).toBeDefined()

  describe "Starting a new game", ->
    game = undefined
    beforeEach ->
      game = new Game words: words

    describe "Default game", ->
      beforeEach -> game.new()

      it "the player 1 should be the current player when starting a game", ->
        expect( game.currentPlayer ).toBe game.player1

      it "a new game should have a second player", ->
        expect( game.player2 ).toBeDefined()

      it "a new game should have a board", ->
        expect( game.board ).toBeDefined()

      it "the method 'new' should have a board with size 5 as default", ->
        expect( game.board.size() ).toBe 5

    describe "Customized game", ->

      it "the method 'new' should have an argument to define the size of board", ->
