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
      @message moveScore
      if moveScore
        @notice moveScore
        $.extend @lastMove, moveScore
        @currentPlayer =
          if @currentPlayer is @player1 then @player2
          else @player1
        @view.update()
      @lastMove

    @initView()
    @

  watchTilesDefault = (tile) ->
    unless @view.selectedTile?
      @view.selectedTile = $.extend {}, tile
      @view.selectedTile.$el.addClass 'selected'
      @message false
    else
      firstCoord  = @view.selectedTile.coordinate
      secondCoord = tile.coordinate
      swapCoordinates = Util.createSwapCoordinate firstCoord, secondCoord
      @move swapCoordinates
      @view.selectedTile.$el.removeClass 'selected'
      @view.selectedTile = undefined
      @message @lastMove.points
    return

  initView: ({watchTiles}={}) ->
    @view = new Game.View
      ELEMENTS: @VIEW
      context: @DOM
      game: @
    @view.updatePlayerNames()
    @view.update()
    @message false
    @view.watchTiles (tile) =>
      if watchTiles? then watchTiles tile
      else watchTilesDefault.call @, tile
    return

  message: (score) ->
    player = @currentPlayer
    id = DEFAULT_VIEW.MESSAGE
    tile = @view.selectedTile

    message = Util.Message.tile {tile, player}
    message = "Invalid move. #{message}" if (not score?)
    Game.View.showMessage {message, context: @DOM, id}
    return

  notice: (score) ->
    if score?
      player = @currentPlayer
      id = DEFAULT_VIEW.NOTICE
      message = Util.Message.points {player, score}
      Game.View.showMessage {message, context: @DOM, id}
    return
