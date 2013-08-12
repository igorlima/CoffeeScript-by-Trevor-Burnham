{Game, Board, Player} = Scrabble
ELEMENTS_VIEW =
  PLAYER:
    ONE:
      SCORE: 'p1score'
      NAME:  'p1name'
    TWO:
      SCORE: 'p2score'
      NAME:  'p2name'
  GRID: 'grid'

DOM_STRINGFIED = "
  <div class='body'>
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
  </div>"

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
        player1 = new Player name: 'Fist player'
        game.new {player1}
        expect( game.player1.name() ).toBe 'Fist player'

      it "the current player should be the player1 when customized", ->
        player1 = new Player name: 'Fist player'
        game.new {player1}
        expect( game.currentPlayer ).toBe game.player1

      it "the player2 might be customized", ->
        player2 = new Player name: 'Second player'
        game.new {player2}
        expect( game.player2.name() ).toBe 'Second player'

      it "the board might be customized", ->
        grid = [['D', 'A'], ['S', 'O']]
        game.new board: new Board {words, grid}
        expect( game.board.size() ).toBe 2

  describe "Game actions", ->

    it "the tile should move", ->


describe "Game View Class", ->
  {View} = Game
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

  describe "Class Methods", ->

    it "the message 'Hello World' should be displayed", ->
      View.showMessage message: 'Hello World', context: DOM, id: 'message'
      expect( $("#message", DOM).html() ).toBe 'Hello World'

    describe "Create a grid line by ['A', 'B', 'C']", ->
      lis = undefined
      beforeEach ->
        lis = View.createGridLine ['A', 'B', 'C']

      it "the lis should contain three elements", ->
        expect( lis.length ).toBe 3

      it "the first element should be an li tag", ->
        expect( $(lis[0]).is('li') ).toBe true

      it "the first element should contain the letter 'A'", ->
        expect( $(lis[0]).html() ).toContain 'A'

      it "the second element should contain the letter 'B'", ->
        expect( $(lis[1]).html() ).toContain 'B'

    describe "Create a grid by
              A | A | A
              X | A | I
              Z | C | D
            ", ->
      uls = undefined
      beforeEach -> uls = View.createGrid [
          ['A', 'A', 'A']
          ['X', 'A', 'I']
          ['Z', 'C', 'D']
        ]

      it "the uls should contain three elements", ->
        expect( uls.length ).toBe 3

      it "the first element should be an ul tag", ->
        expect( $(uls[0]).is('ul') ).toBe true

      it "the first ul should contain 3 li elements", ->
        expect( $('li', uls[0]).length ).toBe 3

    describe "Getting a coordinate of a tile", ->
      $grid = tile_0_0 = tile_1_2 = tile_2_1 = undefined
      beforeEach ->
        $grid = $ "
          <div id='grid'>
            <ul>
              <li>B</li><li>D</li><li>E</li>
            </ul>
            <ul>
              <li>U</li><li>S</li><li>E</li>
            </ul>
            <ul>
              <li>E</li><li>E</li><li>O</li>
            </ul>
          </div>"
        $lis = $ 'li', $grid
        {0: tile_0_0, 7: tile_1_2, 5: tile_2_1} = $lis

      it "the tile coordinate (0,0) SHOULD be {x: 0, y:0}", ->
        expect( View.getCoordinate grid: $grid, tile: tile_0_0 ).toEqual x: 0, y: 0

      it "the tile coordinate (1,2) SHOULD be {x: 1, y:2}", ->
        expect( View.getCoordinate grid: $grid, tile: tile_1_2 ).toEqual x: 1, y: 2

    describe "Creating a swap coordinate", ->

      it "{x:1, y:2} and {x:2, y:2} are given then the swap coordinate should be {x1: 1, y1: 2, x2: 2, y2: 2}", ->
        swapCoordinate = View.createSwapCoordinate {x:1, y:2}, {x:2, y:2}
        expect( swapCoordinate ).toEqual {x1: 1, y1: 2, x2: 2, y2: 2}

      it "{x:1, y:2} and {x:1, y:1} are given then the swap coordinate should be {x1: 1, y1: 2, x2: 1, y2: 1}", ->
        swapCoordinate = View.createSwapCoordinate {x:1, y:2}, {x:1, y:1}
        expect( swapCoordinate ).toEqual {x1: 1, y1: 2, x2: 1, y2: 1}

  describe "Each instance of GameView", ->

    it "the $p1score should be an element DOM wrap by $", ->
      view = new View context: DOM, p1score: 'p1score'
      expect( view.$p1score.length ).toBeGreaterThan 0

    it "the $p2score should be an element DOM wrap by $", ->
      view = new View context: DOM, p2score: 'p2score'
      expect( view.$p2score.length ).toBeGreaterThan 0

    it "the $p1name should be an element DOM wrap by $", ->
      view = new View context: DOM, p1name: 'p1name'
      expect( view.$p1name.length ).toBeGreaterThan 0

    it "the $p2name should be an element DOM wrap by $", ->
      view = new View context: DOM, p2name: 'p2name'
      expect( view.$p2name.length ).toBeGreaterThan 0

    it "the $grid should be an element DOM wrap by $", ->
      view = new View context: DOM, grid: 'grid'
      expect( view.$grid.length ).toBeGreaterThan 0

    it "the game should be defined", ->
      view = new View game: game
      expect( view.game ).toBeDefined()

  describe "DOM", ->

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

    describe "Updating grid", ->
      $uls = undefined
      beforeEach ->
        $grid = $ '#grid', DOM
        $uls = $ 'ul', $grid

      it "the grid should have elements ul", ->
        expect( $uls.length ).toBe 4

      it "the first ul should have 4 li elements", ->
        expect( ($ 'li', $uls[0]).length ).toBe 4

    describe "Watching click on tiles", ->
      view = $tile_0_0 = tile = undefined
      beforeEach ->
        view = new View context: DOM, grid: 'grid'
        view.watchTiles (obj) -> tile = obj
        $lis = $ '#grid li', DOM
        $tile_0_0 = $ $lis[0]
        tile = undefined

      it "an object should be catch by watchTiles", ->
        $tile_0_0.click()
        runs -> expect(tile).toBeDefined()

      it "a coordinate should be catch by watchTiles", ->
        $tile_0_0.click()
        runs -> expect(tile.coordinate).toBeDefined()

      it "the tile catch by watchTiles should be {x:0, y:0}", ->
        $tile_0_0.click()
        runs -> expect(tile.coordinate).toEqual x: 0, y: 0

      it "the unwatchTiles should detaches all event handlers registered", ->
        view.unwatchTiles()
        $tile_0_0.click()
        runs -> expect(tile).not.toBeDefined()
