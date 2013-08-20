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
      @message score: moveScore
      if moveScore
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
      @message tile: tile
    else
      firstCoord  = @view.selectedTile.coordinate
      secondCoord = tile.coordinate
      swapCoordinates = Util.createSwapCoordinate firstCoord, secondCoord
      @move swapCoordinates
      @view.selectedTile.$el.removeClass 'selected'
      @view.selectedTile = undefined

  initView: ({watchTiles}={}) ->
    @view = new Game.View
      ELEMENTS: @VIEW
      context: @DOM
      game: @
    @view.updatePlayerNames()
    @view.update()
    @view.watchTiles (tile) =>
      if watchTiles? then watchTiles tile
      else watchTilesDefault.call @, tile
    return

  message: ({score, tile}) ->
    player = @currentPlayer
    id = DEFAULT_VIEW.MESSAGE
    message = Util.Message.tile {tile, player} if tile?
    message or=
      if score
        id = DEFAULT_VIEW.NOTICE
        Util.Message.points {player, score}
      else
        "Invalid move"
    Game.View.showMessage {message, context: @DOM, id}
    return
