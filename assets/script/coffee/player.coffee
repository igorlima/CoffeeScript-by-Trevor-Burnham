Scrabble = @Scrabble or= {}

Player = Scrabble.Player = class
  constructor: ({name}={}) ->
    [score, moveCount] = [0, 0]

    @name = -> name
    @score = -> score
    @moveCount = -> moveCount
    @move = ({board, swapCoordinates}={}) ->
      return unless board? or swapCoordinates?
      result = board.move swapCoordinates
      if result?
        moveCount++
        score += result.scoreMove
      result
