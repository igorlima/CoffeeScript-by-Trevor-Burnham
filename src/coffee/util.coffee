Util = @Util = class

Util.isInteger = (num) ->
  num is Math.round num

Util.inRange = (params) ->
  {value, size} = params
  (@isInteger value) and 0 <= value < size
