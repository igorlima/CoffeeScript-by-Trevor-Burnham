@Grid = class

  constructor: (options={}) ->
    {size} = options
    throw "Size not given" if (not size) or size < 0

    @size = -> size

  inRange: (x) ->
    0 <= x < @size()