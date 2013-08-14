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
      player1 = player2 = grid = undefined
      beforeEach ->
        player1 = new Player name: 'Fist player'
        player2 = new Player name: 'Second player'
        grid = [['D', 'A'], ['S', 'O']]

      it "the size of game might be customized", ->
        game.new size: 3
        expect( game.board.size() ).toBe 3

      it "the player1 might be customized", ->
        game.new {player1}
        expect( game.player1.name() ).toBe 'Fist player'

      it "the current player should be the player1 when customized", ->
        game.new {player1}
        expect( game.currentPlayer ).toBe game.player1

      it "the player2 might be customized", ->
        game.new {player2}
        expect( game.player2.name() ).toBe 'Second player'

      it "the board might be customized", ->
        game.new board: new Board {words, grid}
        expect( game.board.size() ).toBe 2

  describe "Game actions", ->
    game = board = undefined
    beforeEach ->
      board = new Board
        words: words
        grid: [
          ['A', 'A', 'A', 'A', 'A']
          ['X', 'A', 'I', 'O', 'A']
          ['Z', 'C', 'D', 'D', 'G']
          ['Y', 'A', 'D', 'E', 'A']
          ['M', 'O', 'V', 'S', 'T']
        ]
      game = new Game words: words
      game.new {board}

    describe "a first moving to {x1: 3, y1: 3, x2: 3, y2: 4} ", ->
      beforeEach -> game.move {x1: 3, y1: 3, x2: 3, y2: 4}

      it "lastMove SHOULD be {x1: 3, y1: 3, x2: 3, y2: 4}", ->
        expect( game.lastMove ).toBeDefined()

      it "lastMove SHOULD have a swapCoordinates", ->
        expect( game.lastMove.swapCoordinates ).toBeDefined()

      it "lastMove SHOULD have scoreMove", ->
        expect( game.lastMove.scoreMove ).toBeDefined()

      it "a list of words from the last move SHOULD contains only one word", ->
        expect( game.lastMove.newWords?.length ).toBe 1

      it "the last move SHOULD contains the word 'MOVE'", ->
        expect( game.lastMove.newWords ).toContain 'MOVE'

      it "the score of the last move SHOULD be greater than 0", ->
        expect( game.lastMove.scoreMove ).toBeGreaterThan 0

      it "the amount of move from player1 SHOULD be 1", ->
        expect( game.player1.moveCount() ).toBe 1

      it "after the move, the current player SHOULD be player2", ->
        expect( game.currentPlayer ).toBe game.player2

      describe "a second moving to {x1: 2, y1: 2, x2: 2, y2: 1} ", ->
        beforeEach -> game.move {x1: 2, y1: 2, x2: 2, y2: 1}

        it "the amount of move from player2 SHOULD be 1", ->
          expect( game.player2.moveCount() ).toBe 1

        #console.warn game.lastMove.newWords, game.lastMove.scoreMove


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

    describe "Watching tiles", ->
      view = $tile_1_1 = tile = undefined
      beforeEach ->
        view = new View context: DOM, grid: 'grid'
        view.watchTiles (obj) -> tile = obj
        $lis = $ '#grid li', DOM
        $tile_1_1 = $ $lis[5]
        tile = undefined

      describe "Watching by click", ->

        beforeEach ->
          $tile_1_1.click()

        it "an object should be catch by watchTiles", ->
          runs -> expect(tile).toBeDefined()

        it "a coordinate should be catch by watchTiles", ->
          runs -> expect(tile.coordinate).toBeDefined()

        it "an element should be catch by watchTiles", ->
          runs -> expect(tile.el).toBeDefined()

        it "an element wraped by $ should be catch by watchTiles", ->
          runs -> expect(tile.$el.length).toBe 1

        it "the coordinate tile catch by watchTiles should be {x:1, y:1}", ->
          runs -> expect(tile.coordinate).toEqual x: 1, y: 1

      describe "Unwatching tile", ->

        beforeEach ->
          view.unwatchTiles()

        it "the unwatchTiles should detaches all event handlers registered", ->
          $tile_1_1.click()
          runs -> expect(tile).not.toBeDefined()

      describe "Watching by swipe right", ->
        beforeEach -> $tile_1_1.trigger 'swipeRight'

        it "an object should be catch by watchTiles", ->
          runs -> expect(tile).toBeDefined()

        it "after swipe right, the swipe coordinate catch by watchTiles should be {x:2, y:1}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 2, y: 1

      describe "Watching by swipe left", ->
        beforeEach -> $tile_1_1.trigger 'swipeLeft'

        it "after swipe left, the swipe coordinate catch by watchTiles should be {x:0, y:1}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 0, y: 1

        it "the swapCoordinate should be defined", ->
          runs -> expect(tile.swapCoordinate).toBeDefined()

      describe "Watching by swipe up", ->
        beforeEach -> $tile_1_1.trigger 'swipeUp'

        it "after swipe up, the swipe coordinate catch by watchTiles should be {x:1, y:0}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 1, y: 0

        it "the swapCoordinate should be {x1: 1, y1: 1, x2: 1, y2: 0}", ->
          runs -> expect(tile.swapCoordinate).toEqual {x1: 1, y1: 1, x2: 1, y2: 0}

      describe "Watching by swipe down", ->
        beforeEach -> $tile_1_1.trigger 'swipeDown'

        it "after swipe down, the swipe coordinate catch by watchTiles should be {x:1, y:2}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 1, y: 2
