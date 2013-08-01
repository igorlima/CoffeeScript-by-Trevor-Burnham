{Game, Board, Player} = Scrabble
ELEMENTS_VIEW =
  PLAYER_ONE:
    SCORE: 'p1score'
    NAME:  'p1name'
  PLAYER_TWO:
    SCORE: 'p2score'
    NAME:  'p2name'

DOM_STRINGFIED = "
  <body>
    <p id='message'></p>
    <div id='grid'></div>
    <table id='scores'>
      <tr>
        <th id='p1name'></th>
        <th id='p2name'></th>
      </tr>
      <tr>
        <td id='p1score'></td>
        <td id='p2score'></td>
      </tr>
    </table>
  </body>"

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

    it "the result of a new game should be an instance of Game class", ->
      instance_of_game = game.new()
      expect( instance_of_game instanceof Game ).toBe true

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

      it "the default board size should be 5", ->
        expect( game.board.size() ).toBe 5

    describe "Customized game", ->

      it "the size of game might be customized", ->
        game.new size: 3
        expect( game.board.size() ).toBe 3

      it "the player1 might be customized", ->
        game.new player1: new Player name: 'Fist player'
        expect( game.player1.name() ).toBe 'Fist player'

      it "the current player should be the player1 when customized", ->
        game.new player1: new Player name: 'Fist player'
        expect( game.currentPlayer ).toBe game.player1

      it "the player2 might be customized", ->
        game.new player2: new Player name: 'Second player'
        expect( game.player2.name() ).toBe 'Second player'

      it "the board might be customized", ->
        grid = [['D', 'A'], ['S', 'O']]
        game.new board: new Board {words, grid}
        expect( game.board.size() ).toBe 2

  describe "Game actions", ->

    it "the tile should move", ->


describe "Game View Class", ->
  DOM = game = undefined

  beforeEach ->
    DOM = $ DOM_STRINGFIED
    player1 = new Player name: 'John Doe'
    player2 = new Player name: 'John Smith'
    board = new Board
      words: ['DOES', 'DO', 'DID', 'GET', 'MOVE']
      grid: [
        ['A', 'D', 'A', 'T']
        ['I', 'O', 'E', 'S']
        ['D', 'G', 'D', 'E']
        ['M', 'O', 'V', 'S']
      ]
    game = new Game words: []
    game.new {board, player1, player2, DOM, VIEW: ELEMENTS_VIEW}

  describe "Each instance of game view", ->

    it "the $p1score should be an element DOM wrap by $", ->
      view = new Game.View context: DOM, p1score: 'p1score'
      expect( view.$p1score.length ).toBeGreaterThan 0

    it "the $p2score should be an element DOM wrap by $", ->
      view = new Game.View context: DOM, p2score: 'p2score'
      expect( view.$p2score.length ).toBeGreaterThan 0

    it "the $p1name should be an element DOM wrap by $", ->
      view = new Game.View context: DOM, p1name: 'p1name'
      expect( view.$p1name.length ).toBeGreaterThan 0

    it "the $p2name should be an element DOM wrap by $", ->
      view = new Game.View context: DOM, p2name: 'p2name'
      expect( view.$p2name.length ).toBeGreaterThan 0

    it "the game should be defined", ->
      view = new Game.View game: game
      expect( view.game ).toBeDefined()

  describe "Updating the DOM", ->

    describe "Updating the score", ->

      it "the player 1 score should be set", ->
        expect( $("#p1score", DOM).html() ).toBe '0'

      it "the player 2 score should be set", ->
        expect( $("#p2score", DOM).html() ).toBe '0'

    describe "Updating player names", ->

      it "the player 1 name should be set", ->
        expect( $("#p1name", DOM).html() ).toBe 'John Doe'

      it "the player 2 name should be set", ->
        expect( $("#p2name", DOM).html() ).toBe 'John Smith'
