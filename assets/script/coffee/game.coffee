Scrabble = @Scrabble or= {}
DEFAULT_VIEW =
  PLAYER:
    ONE:
      SCORE: 'p1score'
      NAME:  'p1name'
    TWO:
      SCORE: 'p2score'
      NAME:  'p2name'
  MESSAGE: 'message'
  GRID: 'grid'

Game = Scrabble.Game = class
  constructor: ({@words}={}) ->
    unless @words? then throw new Error "Board or words was not given"

  new: ({size, player1, player2, board, @DOM, VIEW}={}) ->
    @board = board or new Scrabble.Board size: size or 5, words: @words
    @currentPlayer = @player1 = player1 or new Scrabble.Player name: 'Player 1'
    @player2 = player2 or new Scrabble.Player name: 'Player 2'
    @VIEW = VIEW or DEFAULT_VIEW
    @move = (swapCoordinates) =>
      @lastMove = $.extend {}, {swapCoordinates}
      moveScore = @currentPlayer.move {board: @board, swapCoordinates}
      @showMessage score: moveScore
      if moveScore
        $.extend @lastMove, moveScore
        @currentPlayer = if @currentPlayer is @player1 then @player2 else @player1
        @view.update()
      @lastMove

    @initView()
    @

  initView: ->
    @view = new View
      p1score: @VIEW.PLAYER.ONE.SCORE
      p2score: @VIEW.PLAYER.TWO.SCORE
      p1name:  @VIEW.PLAYER.ONE.NAME
      p2name:  @VIEW.PLAYER.TWO.NAME
      grid:    @VIEW.GRID
      context: @DOM
      game: @
    @view.updatePlayerNames()
    @view.update()
    @view.watchTiles (tile) =>
      unless @view.selectedTile?
        @view.selectedTile = $.extend {}, tile
        @view.selectedTile.$el.addClass 'selected'
        @showMessage tile: tile
      else
        firstCoord  = @view.selectedTile.coordinate
        secondCoord = tile.coordinate
        swapCoordinates = Scrabble.Util.createSwapCoordinate firstCoord, secondCoord
        @move swapCoordinates
        @view.selectedTile.$el.removeClass 'selected'
        @view.selectedTile = undefined
    return

  showMessage: ({score, tile}) ->
    message = Scrabble.Util.Message.tile tile if tile?
    message or=
      if score
        Scrabble.Util.Message.points {player: @currentPlayer, score: score}
      else
        "Invalid move"
    View.showMessage {message, context: @DOM}
    return

View = Game.View = class
  constructor: ({p1score, p2score, p1name, p2name, context, grid, @game}={}) ->
    @watcherTiles = []

    @$p1name  = $ "##{p1name}", context
    @$p1score = $ "##{p1score}", context
    @$p2name  = $ "##{p2name}", context
    @$p2score = $ "##{p2score}", context
    @$grid    = $ "##{grid}", context

  updateScore: ->
    p1score = @game?.player1?.score()
    p2score = @game?.player2?.score()
    @$p1score.html p1score
    @$p2score.html p2score

  updatePlayerNames: ->
    @$p1name.html @game.player1.name()
    @$p2name.html @game.player2.name()

  updateGrid: ->
    @$grid.empty().append( View.createGrid @game.board.matrix() )
    @registerWatchTiles watcher for watcher in @watcherTiles
    @$grid

  update: ->
    @updateScore()
    @updateGrid()
    @

  watchTiles: (callback) ->
    @watcherTiles.push callback
    @registerWatchTiles callback

  registerWatchTiles: (callback) ->
    $grid = @$grid
    tile = {}
    $grid.find('li').on
      "catchTileInfo": (event) ->
        coordinate      = View.getCoordinate grid: $grid, tile: @
        swipeCoordinate = Scrabble.Util.createSwipeCoordinate coordinate, event.data or {}
        swapCoordinate  = Scrabble.Util.createSwapCoordinate coordinate, swipeCoordinate
        $.extend tile, {coordinate, el: @, $el: $(@)}
        $.extend tile, {swipeCoordinate, swapCoordinate} if event.data?
        callback tile
      "click": -> $(@).trigger 'catchTileInfo'
      "swipeRight": -> $(@).trigger 'catchTileInfo', {x: 1}
      "swipeLeft":  -> $(@).trigger 'catchTileInfo', {x: -1}
      "swipeUp":    -> $(@).trigger 'catchTileInfo', {y: -1}
      "swipeDown":  -> $(@).trigger 'catchTileInfo', {y: 1}

  unwatchTiles: ->
    @watcherTiles = []
    @$grid.find('li').off()

View.showMessage = ({message, context, id}={}) ->
  $id = $ "##{id or DEFAULT_VIEW.MESSAGE}", context
  $id.html message

View.createGridLine = (line) ->
  lineHtml = ''
  lineHtml += "<li>#{value}</li>" for value in line
  $ lineHtml

View.createGrid = (grid) ->
  gridHtml = $ '<div>'
  for line in grid
    ul = $ '<ul>'
    gridHtml.append ul.append(@createGridLine line)
  gridHtml.contents()

View.getCoordinate = ({grid, tile}) ->
  $li = $ tile
  $ul = $li.parent()
  $lis = $ul.children()
  $uls = $ul.parent().children()

  x: $lis.index($li), y: $uls.index($ul)
