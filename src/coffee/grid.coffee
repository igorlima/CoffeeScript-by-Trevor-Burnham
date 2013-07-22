@Grid = class

  tileCounts =
    A: 9, B: 2, C: 2, D: 4, E: 12, F: 2, G: 3, H: 2, I: 9, J: 1, K: 1, L: 4
    M: 2, N: 6, O: 8, P: 2, Q: 1,  R: 6, S: 4, T: 6, U: 4, V: 2, W: 2, X: 1
    Y: 2, Z: 1

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    coordinates = []
    coordinates[row] = [] for row in [0...size]
    @set = (coordinate) ->
      {x, y, value} = coordinate
      if @inRange(x) and @inRange(y) then coordinates[x][y] = value
      else coordinates[x][y] = undefined

      !!coordinates[x][y]

    @get = (coordinate) ->
      {x, y} = coordinate
      coordinates[x][y]

    wordList = (word for word in Words when word.length <= size)
    @isWord = (str) ->
      str in wordList

  inRange: (num) ->
    (@isInteger num) and 0 <= num < @size()

  isInteger: (num) ->
    num is Math.round num

  totalTiles: ->
    totalTiles = 0
    totalTiles += count for letter, count of tileCounts
    totalTiles

  alphabet: ->
    (letter for letter of tileCounts).sort()

  randomLetter: ->
    randomNumber = Math.ceil Math.random() * @totalTiles()
    x = 1
    for letter in @alphabet()
      x += tileCounts[letter]
      return letter if x > randomNumber
