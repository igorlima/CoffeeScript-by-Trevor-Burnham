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

  new: ({size, player1, player2, board, DOM, VIEW}={}) ->
    @board = board or new Scrabble.Board size: size or 5, words: @words
    @currentPlayer = @player1 = player1 or new Scrabble.Player name: 'Player 1'
    @player2 = player2 or new Scrabble.Player name: 'Player 2'

    VIEW or= DEFAULT_VIEW
    @view = new View
      p1score: VIEW.PLAYER.ONE.SCORE
      p2score: VIEW.PLAYER.TWO.SCORE
      p1name:  VIEW.PLAYER.ONE.NAME
      p2name:  VIEW.PLAYER.TWO.NAME
      grid:    VIEW.GRID
      context: DOM
      game: @
    @view.updateScore()
    @view.updatePlayerNames()
    @view.updateGrid()
    @

View = Game.View = class
  constructor: ({p1score, p2score, p1name, p2name, context, grid, @game}={}) ->
    @$p1name  = $ "##{p1name}", context
    @$p1score = $ "##{p1score}", context

    @$p2name  = $ "##{p2name}", context
    @$p2score = $ "##{p2score}", context

    @$grid = $ "##{grid}", context

  updateScore: ->
    @$p1score.html 0
    @$p2score.html 0

  updatePlayerNames: ->
    @$p1name.html @game.player1.name()
    @$p2name.html @game.player2.name()

  updateGrid: ->
    @$grid.empty().append( View.createGrid @game.board.matrix() )

  watchTiles: (callback) ->
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
    @$grid.find('li').off()

View.showMessage = ({message, context, id}={}) ->
  $id = $ "##{id or DEFAULT_VIEW.MESSAGE}", context
  $id.html message

View.createGridLine = (line) ->
  lineHtml = ''
  for value in line
    lineHtml += "<li>#{value}</li>"
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
