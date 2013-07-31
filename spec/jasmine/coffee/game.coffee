{Game, Board} = Scrabble

describe "Game class", ->

  describe "Each instance of game", ->
    words = undefined
    beforeEach ->
      words = ['DOES', 'DO', 'DID', 'GET', 'MOVE']

    it "an exception should raise when instanciating the game without a list of word and without a board", ->
      expect( -> new Game() ).toThrow()

    it "the game should have a list of word", ->
      game = new Game words: words
      expect( game.words ).toBeDefined()

  describe "Starting a new game", ->

    it "the player 1 should be the current player when starting a game", ->

    it "the method 'new' should have a board with size 5 as default", ->

    it "the method 'new' should have an argument to define the size of board", ->

    it "the game should have two players", ->

    it "the game should have a board", ->

