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
    game = new Game words: words

    it "the player 1 should be the current player when starting a game", ->
      game.new()
      expect( game.currentPlayer ).toBe game.player1

    it "the method 'new' should have a board with size 5 as default", ->

    it "the method 'new' should have an argument to define the size of board", ->

    it "the game should have two players", ->

    it "the game should have a board", ->
