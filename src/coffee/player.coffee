Scrabble = @Scrabble or= {}

Player = Scrabble.Player = class
  constructor: ({name}) ->
    [score, moveCount] = [0, 0]

    @name = -> name
    @score = -> score
    @moveCount = -> moveCount
