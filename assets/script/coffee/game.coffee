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

Game = Scrabble.Game = class
  constructor: ({@words}={}) ->
    throw "Board or words was not given" unless @words?

  new: ({size, player1, player2, board, DOM, VIEW}={}) ->
    @board = board or new Scrabble.Board size: size or 5, words: @words
    @currentPlayer = @player1 = player1 or new Scrabble.Player name: 'Player 1'
    @player2 = player2 or new Scrabble.Player name: 'Player 2'

    VIEW or= DEFAULT_VIEW
    @view = new Game.View
      p1score: VIEW.PLAYER.ONE.SCORE
      p2score: VIEW.PLAYER.TWO.SCORE
      p1name:  VIEW.PLAYER.ONE.NAME
      p2name:  VIEW.PLAYER.TWO.NAME
      context: DOM
      game: @
    @view.updateScore()
    @view.updatePlayerNames()
    @

Game.View = class
  constructor: ({p1score, p2score, p1name, p2name, context, @game}={}) ->
    @$p1name  = $ "##{p1name}", context
    @$p1score = $ "##{p1score}", context

    @$p2name  = $ "##{p2name}", context
    @$p2score = $ "##{p2score}", context

  updateScore: ->
    @$p1score.html 0
    @$p2score.html 0

  updatePlayerNames: ->
    @$p1name.html @game.player1.name()
    @$p2name.html @game.player2.name()

Game.View.showMessage = ({message, context, id}={}) ->
  $id = $ "##{id or DEFAULT_VIEW.MESSAGE}", context
  $id.html message

Game.View.createGridLine = (line) ->
  lineHtml = ''
  for value in line
    lineHtml += "<li>#{value}</li>"
  $ lineHtml

Game.View.createGrid = (grid) ->
  gridHtml = $ '<div>'
  for line in grid
    ul = $ '<ul>'
    gridHtml.append ul.append(@createGridLine line)
  gridHtml.contents()
