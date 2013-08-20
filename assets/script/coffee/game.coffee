Scrabble = @Scrabble
{Board, Player, Util, defaultView} = Scrabble
DEFAULT_VIEW = defaultView()

Game = Scrabble.Game = class
  constructor: ({@words}={}) ->
    unless @words? then throw new Error "Board or words was not given"

  new: ({size, player1, player2, board, @DOM, VIEW}={}) ->
    @board = board or new Board size: size or 5, words: @words
    @currentPlayer = @player1 = player1 or new Player name: 'Player 1'
    @player2 = player2 or new Player name: 'Player 2'
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

  watchTilesDefault = (tile) ->
    unless @view.selectedTile?
      @view.selectedTile = $.extend {}, tile
      @view.selectedTile.$el.addClass 'selected'
      @showMessage tile: tile
    else
      firstCoord  = @view.selectedTile.coordinate
      secondCoord = tile.coordinate
      swapCoordinates = Util.createSwapCoordinate firstCoord, secondCoord
      @move swapCoordinates
      @view.selectedTile.$el.removeClass 'selected'
      @view.selectedTile = undefined

  initView: ({watchTiles}={}) ->
    @view = new Game.View
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
      if watchTiles? then watchTiles tile
      else watchTilesDefault.call @, tile
    return

  showMessage: ({score, tile}) ->
    message = Util.Message.tile tile if tile?
    message or=
      if score
        Util.Message.points {player: @currentPlayer, score: score}
      else
        "Invalid move"
    Game.View.showMessage {message, context: @DOM}
    return
