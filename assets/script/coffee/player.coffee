Player = @Scrabble.Player = class
  constructor: ({name}={}) ->
    [score, moveCount, words] = [0, 0, []]

    @name = -> name
    @score = -> score
    @moveCount = -> moveCount
    @words = -> word for word in words
    @move = ({board, swapCoordinates}={}) ->
      return unless board? or swapCoordinates?
      result = board.move swapCoordinates
      if result?
        moveCount++
        score += result.points
        words.push result.newWords...
      result
