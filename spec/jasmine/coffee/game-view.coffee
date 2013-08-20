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

    it "message 'Hello World' should be displayed", ->
      View.showMessage message: 'Hello World', context: DOM, id: 'message'
      expect( $("#message", DOM).html() ).toBe 'Hello World'

    describe "Create a grid line by ['A', 'B', 'C']", ->
      lis = undefined
      beforeEach ->
        lis = View.createGridLine ['A', 'B', 'C']

      it "the lis should contain three elements", ->
        expect( lis.length ).toBe 3

      it "first element SHOULD be an li tag", ->
        expect( $(lis[0]).is('li') ).toBe true

      it "first element SHOULD contain the letter 'A'", ->
        expect( $(lis[0]).html() ).toContain 'A'

      it "second element SHOULD contain the letter 'B'", ->
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

      it "first element should be an ul tag", ->
        expect( $(uls[0]).is('ul') ).toBe true

      it "first ul should contain 3 li elements", ->
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

      it "tile coordinate (0,0) SHOULD be {x: 0, y:0}", ->
        expect( View.getCoordinate grid: $grid, tile: tile_0_0 ).toEqual x: 0, y: 0

      it "tile coordinate (1,2) SHOULD be {x: 1, y:2}", ->
        expect( View.getCoordinate grid: $grid, tile: tile_1_2 ).toEqual x: 1, y: 2


  describe "Each instance of GameView", ->
    view = undefined
    beforeEach ->
      view = new View context: DOM, ELEMENTS: ELEMENTS_VIEW, game: game

    it "$p1score SHOULD be an element DOM wrap by $", ->
      expect( view.$p1score.length ).toBeGreaterThan 0

    it "$p2score SHOULD be an element DOM wrap by $", ->
      expect( view.$p2score.length ).toBeGreaterThan 0

    it "$p1name SHOULD be an element DOM wrap by $", ->
      expect( view.$p1name.length ).toBeGreaterThan 0

    it "$p2name SHOULD be an element DOM wrap by $", ->
      expect( view.$p2name.length ).toBeGreaterThan 0

    it "$grid SHOULD be an element DOM wrap by $", ->
      expect( view.$grid.length ).toBeGreaterThan 0

    it "game SHOULD be defined", ->
      expect( view.game ).toBeDefined()

  describe "DOM", ->
    $p1score = -> $ "#p1score", DOM
    $p2score = -> $ "#p2score", DOM
    p1score  = -> +$p1score().html()
    p2score  = -> +$p2score().html()
    view = undefined
    beforeEach ->
      view = new View
        context: DOM
        ELEMENTS: ELEMENTS_VIEW
        game: game

    describe "Updating the score", ->

      it "player 1 score should be set as 0", ->
        expect( p1score() ).toBe 0

      it "player 2 score should be set as 0", ->
        expect( p2score() ).toBe 0

      describe "first move from (3, 2) to (3, 3)", ->
        p1score_on_first_move = undefined
        beforeEach ->
          game.move x1: 3, y1: 2, x2: 3, y2: 3
          view.updateScore()
          p1score_on_first_move = p1score()

        it "player 1 score SHOULD be greater than 0", ->
          expect( p1score_on_first_move ).toBeGreaterThan 0

        it "player 2 score SHOULD be 0", ->
          expect( p2score() ).toBe 0

        describe "second move from (1, 0) to (0, 0)", ->
          beforeEach ->
            game.move x1: 1, y1: 0, x2: 0, y2: 0
            view.updateScore()

          it "player 1 score SHOULD be same as the first move", ->
            expect( p1score_on_first_move ).toBe p1score()

          it "player2 score SHOULD be greater than 0", ->
            expect( p2score() ).toBeGreaterThan 0

    describe "Updating player names", ->

      it "player 1 name SHOULD be set", ->
        expect( $("#p1name", DOM).html() ).toBe 'John Doe'

      it "player 2 name SHOULD be set", ->
        expect( $("#p2name", DOM).html() ).toBe 'John Smith'

    describe "Updating grid", ->
      $uls = undefined
      beforeEach ->
        $grid = $ '#grid', DOM
        $uls = $ 'ul', $grid

      it "grid SHOULD have elements ul", ->
        expect( $uls.length ).toBe 4

      it "first ul tag SHOULD have 4 li elements", ->
        expect( ($ 'li', $uls[0]).length ).toBe 4

    describe "Watching tiles", ->
      $lis      = -> $ '#grid li', DOM
      $tile_1_1 = -> $ $lis()[5]
      view = tile = undefined
      beforeEach ->
        view = new View context: DOM, ELEMENTS: ELEMENTS_VIEW, game: game
        view.watchTiles (obj) -> tile = obj
        tile = undefined

      it "watchTiles SHOULD not return anything", ->
        expect( view.watchTiles -> ).not.toBeDefined()

      it "registerWatchTiles SHOULD not return anything", ->
        expect( view.registerWatchTiles -> ).not.toBeDefined()

      describe "Watching by click", ->
        beforeEach -> $tile_1_1().click()

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

      describe "Updating grid with watcher", ->
        beforeEach ->
          view.updateGrid()
          $tile_1_1().click()

        it "watcher SHOULD be working", ->
          runs -> expect(tile).toBeDefined()

      describe "Unwatching tile", ->
        unwatchTilesReturn = undefined

        beforeEach ->
          unwatchTilesReturn = view.unwatchTiles()

        it "unwatchTiles SHOULD SHOULD not return anything", ->
          expect( unwatchTilesReturn ).not.toBeDefined()

        it "unwatchTiles SHOULD detaches all event handlers registered", ->
          $tile_1_1().click()
          runs -> expect(tile).not.toBeDefined()

        it "watcherTiles SHOULD be empty", ->
          expect( view.watcherTiles?.length ).toBe 0

      describe "Watching by swipe right", ->
        beforeEach -> $tile_1_1().trigger 'swipeRight'

        it "an object should be catch by watchTiles", ->
          runs -> expect(tile).toBeDefined()

        it "after swipe right, the swipe coordinate catch by watchTiles should be {x:2, y:1}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 2, y: 1

      describe "Watching by swipe left", ->
        beforeEach -> $tile_1_1().trigger 'swipeLeft'

        it "after swipe left, the swipe coordinate catch by watchTiles should be {x:0, y:1}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 0, y: 1

        it "the swapCoordinate should be defined", ->
          runs -> expect(tile.swapCoordinate).toBeDefined()

      describe "Watching by swipe up", ->
        beforeEach -> $tile_1_1().trigger 'swipeUp'

        it "after swipe up, the swipe coordinate catch by watchTiles should be {x:1, y:0}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 1, y: 0

        it "swapCoordinate SHOULD be {x1: 1, y1: 1, x2: 1, y2: 0}", ->
          runs -> expect(tile.swapCoordinate).toEqual {x1: 1, y1: 1, x2: 1, y2: 0}

      describe "Watching by swipe down", ->
        beforeEach -> $tile_1_1().trigger 'swipeDown'

        it "after swipe down, the swipe coordinate catch by watchTiles should be {x:1, y:2}", ->
          runs -> expect(tile.swipeCoordinate).toEqual x: 1, y: 2
