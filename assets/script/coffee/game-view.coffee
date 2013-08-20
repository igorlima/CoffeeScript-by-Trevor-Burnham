Scrabble = @Scrabble
{Util, Game, defaultView} = Scrabble
DEFAULT_VIEW = defaultView()

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
        swipeCoordinate = Util.createSwipeCoordinate coordinate, event.data or {}
        swapCoordinate  = Util.createSwapCoordinate coordinate, swipeCoordinate
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
