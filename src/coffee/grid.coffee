@Grid = class

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not size) or size < 0

    @size = -> size

  inRange: (num) ->
    (@isInteger num) and 0 <= num < @size()

  isInteger: (num) ->
    num is Math.round num
