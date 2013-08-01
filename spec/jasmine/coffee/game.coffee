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

      it "the first player should have the name 'Player 1'", ->
        expect( game.player1.name() ).toBe 'Player 1'

      it "a new game should have a second player", ->
        expect( game.player2 ).toBeDefined()

      it "the second player should have the name 'Player 2'", ->
        expect( game.player2.name() ).toBe 'Player 2'

      it "a new game should have a board", ->
        expect( game.board ).toBeDefined()

      it "the method 'new' should have a board with size 5 as default", ->
        expect( game.board.size() ).toBe 5

    describe "Customized game", ->

      it "the size of game might be customized", ->
        game.new size: 3
        expect( game.board.size() ).toBe 3

      it "the player1 might be customized", ->
        game.new player1: new Scrabble.Player name: 'Fist player'
        expect( game.player1.name() ).toBe 'Fist player'

      it "the current player should be the player1 when customized", ->
        game.new player1: new Scrabble.Player name: 'Fist player'
        expect( game.currentPlayer ).toBe game.player1

      it "the player2 might be customized", ->
        game.new player2: new Scrabble.Player name: 'Second player'
        expect( game.player2.name() ).toBe 'Second player'

      it "the board might be customized", ->
        grid = [['D', 'A'], ['S', 'O']]
        game.new board: new Board {words, grid}
        expect( game.board.size() ).toBe 2

  describe "Game actions", ->

    it "the tile should move", ->

  describe "Updating a game on DOM", ->

    it "", ->
