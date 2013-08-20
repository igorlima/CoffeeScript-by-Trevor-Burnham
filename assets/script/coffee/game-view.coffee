Scrabble = @Scrabble
{Util, Game, defaultView} = Scrabble
DEFAULT_VIEW = defaultView()

View = Game.View = class
  constructor: ({ELEMENTS, context, @game}={}) ->
    @watcherTiles = []

    @$p1name    = $ "##{ELEMENTS?.PLAYER?.ONE?.NAME}", context
    @$p1score   = $ "##{ELEMENTS?.PLAYER?.ONE?.SCORE}", context
    @$p1message = $ "##{ELEMENTS?.PLAYER?.ONE?.MSG}", context
    @$p2name    = $ "##{ELEMENTS?.PLAYER?.TWO?.NAME}", context
    @$p2score   = $ "##{ELEMENTS?.PLAYER?.TWO?.SCORE}", context
    @$p2message = $ "##{ELEMENTS?.PLAYER?.TWO?.MSG}", context
    @$grid      = $ "##{ELEMENTS?.GRID}", context

  updateScore: ->
    p1score = @game?.player1?.score()
    p2score = @game?.player2?.score()
    @$p1score.html p1score
    @$p2score.html p2score
    return

  updatePlayerNames: ->
    @$p1name.html @game.player1.name()
    @$p2name.html @game.player2.name()
    return

  updatePlayerWords: ->
    p2words = p1words = ''
    p1words += "#{word} " for word in @game.player1.words()
    p2words += "#{word} " for word in @game.player2.words()
    @$p1message.html "#{p1words}"
    @$p2message.html "#{p2words}"
    return

  updateGrid: ->
    @$grid.empty().append( View.createGrid @game.board.matrix() )
    @registerWatchTiles watcher for watcher in @watcherTiles
    return

  update: ->
    @updateScore()
    @updatePlayerWords()
    @updateGrid()
    return

  watchTiles: (callback) ->
    @watcherTiles.push callback
    @registerWatchTiles callback
    return

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
    return

  unwatchTiles: ->
    @watcherTiles = []
    @$grid.find('li').off()
    return

View.showMessage = ({message, context, id}={}) ->
  $id = $ "##{id}", context
  $id.html message
  return

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
