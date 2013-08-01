Scrabble = @Scrabble or= {}

Game = Scrabble.Game = class
  constructor: ({@words}={}) ->
    throw "Board or words was not given" unless @words?

  new: ({size}={}) ->
    @board = new Scrabble.Board size: size or 5, words: @words
    @currentPlayer = @player1 = new Scrabble.Player name: 'Player 1'
    @player2 = new Scrabble.Player name: 'Player 2'
###
  updateView: ->
    if @player1? and @player2?
      $("#p1name").html @player1.name()
      $("#p1score").html 0

      $("#p2name").html @player2.name()
      $("#p2score").html 0
###
