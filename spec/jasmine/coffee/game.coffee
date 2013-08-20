{Game, Board, Player} = Scrabble
ELEMENTS_VIEW =
  PLAYER:
    ONE:
      SCORE: 'p1score'
      NAME:  'p1name'
      MSG:   'p1message'
    TWO:
      SCORE: 'p2score'
      NAME:  'p2name'
      MSG:   'p2message'
  MESSAGE: 'message'
  NOTICE:  'notice'
  GRID: 'grid'

DOM_STRINGFIED = "
  <div class='body'>
    <p id='message'></p>
    <div id='grid'></div>
    <p id='notice'></p>
    <table id='scores'>
      <tr>
        <th id='p1name'></th>
        <th id='p2name'></th>
      </tr>
      <tr>
        <td id='p1score'></td>
        <td id='p2score'></td>
      </tr>
      <tr>
        <td id='p1message'></td>
        <td id='p2message'></td>
      </tr>
    </table>
  </div>"

describe "Game class", ->
  $lis  = -> $ '#grid li', DOM
  DOM   = undefined
  words = ['DOES', 'DO', 'DID', 'GET', 'MOVE']
  beforeEach -> DOM = $ DOM_STRINGFIED

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

    describe "initView method", ->
      tile_0_0  = -> $lis()[0]
      $tile_0_0 = -> $ tile_0_0()
      beforeEach -> game.new {DOM, VIEW: ELEMENTS_VIEW}

      describe "default", ->
        resultInitView = undefined
        beforeEach -> resultInitView = game.initView()

        it "SHOULD not have any return", ->
          expect( resultInitView ).not.toBeDefined()

      describe "customized", ->
        selectedTile = count = undefined
        beforeEach ->
          count = 0
          game.initView watchTiles: (tile) ->
            selectedTile = tile
            count++
          $tile_0_0().click()

        it "count SHOULD be 1", ->
          expect( count ).toBe 1

        it "selectedTile SHOULD be defined", ->
          expect( selectedTile ).toBeDefined()

        it "game.view.selectedTile SHOULD not be defined, because the watchTiles default was overridden", ->
          expect( game.view.selectedTile ).not.toBeDefined()

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
    $message = -> $ "#message", DOM
    $notice  = -> $ "#notice", DOM
    message  = -> $message().html()
    notice   = -> $notice().html()
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
      game = new Game {words}

    describe "method game.move(...)", ->
      beforeEach -> game.new {board, DOM}

      describe "a first moving to {x1: 3, y1: 3, x2: 3, y2: 4} ", ->
        beforeEach -> game.move {x1: 3, y1: 3, x2: 3, y2: 4}

        it "lastMove SHOULD be {x1: 3, y1: 3, x2: 3, y2: 4}", ->
          expect( game.lastMove ).toBeDefined()

        it "lastMove SHOULD have a swapCoordinates", ->
          expect( game.lastMove.swapCoordinates ).toBeDefined()

        it "lastMove SHOULD have points", ->
          expect( game.lastMove.points ).toBeDefined()

        it "a list of words from the last move SHOULD contains only one word", ->
          expect( game.lastMove.newWords?.length ).toBe 1

        it "the last move SHOULD contains the word 'MOVE'", ->
          expect( game.lastMove.newWords ).toContain 'MOVE'

        it "points from last move SHOULD be greater than 0", ->
          expect( game.lastMove.points ).toBeGreaterThan 0

        it "the amount of move from player1 SHOULD be 1", ->
          expect( game.player1.moveCount() ).toBe 1

        it "after the move, the current player SHOULD be player2", ->
          expect( game.currentPlayer ).toBe game.player2

        it "a notice SHOULD appear containing the player name and the points", ->
          expect( notice() ).toMatch /Player 1 (.)+ points/

        describe "a second moving to {x1: 2, y1: 2, x2: 2, y2: 1} ", ->
          beforeEach -> game.move {x1: 2, y1: 2, x2: 2, y2: 1}

          it "the amount of move from player2 SHOULD be 1", ->
            expect( game.player2.moveCount() ).toBe 1

          it "points from last move SHOULD be greater than 0", ->
            expect( game.lastMove.points ).toBeGreaterThan 0

          it "after the move, the current player SHOULD be player1", ->
            expect( game.currentPlayer ).toBe game.player1

    describe "by clicking", ->
      $p1score = -> $ "#p1score", DOM
      $p2score = -> $ "#p2score", DOM
      $p1message = -> $ "#p1message", DOM
      $p2message = -> $ "#p2message", DOM
      p1score  = -> +$p1score().html()
      p2score  = -> +$p2score().html()
      p1message  = -> $p1message().html()
      p2message  = -> $p2message().html()
      beforeEach ->
        game.new {board, DOM}

      describe "a first click on (3, 1) ", ->
        tile_3_1  = -> $lis()[8]
        $tile_3_1 = -> $ tile_3_1()
        beforeEach -> $tile_3_1().click()

        it "the selected tile on game view SHOULD be defined", ->
          expect( game.view.selectedTile ).toBeDefined()

        it "the selected tile SHOULD have a coordinate", ->
          expect( game.view.selectedTile.coordinate ).toBeDefined()

        it "the coordinate SHOULD be {x:3, y:1}", ->
          expect( game.view.selectedTile.coordinate ).toEqual x: 3, y: 1

        it "last move SHOULD not be defined", ->
          expect( game.lastMove ).not.toBeDefined()

        it "the tile SHOULD be selected", ->
          expect( $tile_3_1().hasClass('selected') ).toBe true

        it "a message SHOULD appear containing the word 'selected'", ->
          expect( message() ).toContain "selected"

        it "a message SHOULD appear containing 'tile (3, 1)'", ->
          expect( message() ).toMatch /[Tt]ile [(]3, 1[)]/

        it "a message SHOULD appear containing 'Player 1'", ->
          expect( message() ).toContain "Player 1"

        describe "a second click on a invalid tile (3, 3) ", ->
          tile_3_3  = -> $lis()[18]
          $tile_3_3 = -> $ tile_3_3()
          beforeEach -> $tile_3_3().click()

          it "the tile SHOULD not be selected", ->
            expect( $tile_3_1().hasClass 'selected' ).not.toBe true

          it "a message SHOULD appear containing 'Invalid move'", ->
            expect( message() ).toContain "Invalid move"

        describe "a second click on same tile (3, 1) ", ->
          beforeEach -> $tile_3_1().click()

          it "the current player SHOULD be player1", ->
            expect( game.currentPlayer is game.player1 ).toBe true

          it "the player1 score SHOULD be 0", ->
            expect( game.player1.score() ).toBe 0

          it "the tile SHOULD not be selected", ->
            expect( $tile_3_1().hasClass('selected') ).not.toBe true

          it "the selected tile SHOULD not be defined", ->
            expect( game.view.selectedTile ).not.toBeDefined()

        describe "a second click on (3, 2) ", ->
          tile_3_2  = -> $lis()[13]
          $tile_3_2 = undefined
          beforeEach ->
            $tile_3_2 = $ tile_3_2()
            $tile_3_2.click()

          it "the selected tile on game view SHOULD not be defined", ->
            expect( game.view.selectedTile ).not.toBeDefined()

          it "last move SHOULD be defined", ->
            expect( game.lastMove ).toBeDefined()

          it "last move SHOULD have a swapCoordinate", ->
            expect( game.lastMove.swapCoordinates ).toBeDefined()

          it "last move SHOULD have a swapCoordinate as {x1: 3, y1: 1, x2: 3, y2: 2} ", ->
            expect( game.lastMove?.swapCoordinates ).toEqual {x1: 3, y1: 1, x2: 3, y2: 2}

          it "points from last move SHOULD be greater than 0", ->
            expect( game.lastMove.points ).toBeGreaterThan 0

          it "after player1 moved, the current palyer SHOULD be player2", ->
            expect( game.currentPlayer is game.player2 ).toBe true

          it "after swaped, the tile (3, 1) SHOULD be a letter 'D'", ->
            expect( tile_3_1()?.innerHTML ).toBe 'D'

          it "player1 score SHOULD be greater than 0", ->
            expect( p1score() ).toBeGreaterThan 0

          it "a notice SHOULD appear containing the player name and the points", ->
            expect( notice() ).toMatch /Player 1 (.)+ points/

          it "word list for player 1 SHOULD contain 'DOES'", ->
            expect( p1message() ).toContain 'DOES'

          describe "a third click on (2, 2) ", ->
            tile_2_2  = -> $lis()[12]
            $tile_2_2 = -> $ tile_2_2()
            beforeEach ->
              $tile_2_2().click()

            it "the coordinate SHOULD be {x:2, y:2}", ->
              expect( game.view.selectedTile.coordinate ).toEqual x: 2, y: 2

            it "a message SHOULD appear containing the word 'selected'", ->
              expect( message() ).toContain "selected"

            it "a message SHOULD appear containing 'Tile (2, 2)'", ->
              expect( message() ).toMatch /[Tt]ile [(]2, 2[)]/
