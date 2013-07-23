@Grid = class

  # Probabilities are taken from Scrablle, except that there are no blanks
  # See http://www.zyzzyva.net/wordlists.shtml
  tileCounts =
    A: 9, B: 2, C: 2, D: 4, E: 12, F: 2, G: 3, H: 2, I: 9, J: 1, K: 1, L: 4
    M: 2, N: 6, O: 8, P: 2, Q: 1,  R: 6, S: 4, T: 6, U: 4, V: 2, W: 2, X: 1
    Y: 2, Z: 1

  constructor: (options={}) ->
    {size} = options
    throw "Grid size not given" if (not !!size) or size < 0
    @size = -> size

    coordinates = []
    @set = (coordinate) ->
      {x, y, value} = coordinate
      Util.setCoordinate { coordinates, range: size, x, y, value }

    @get = (coordinate) ->
      {x, y} = coordinate
      Util.getCoordinate { coordinates, x, y }

    wordList = (word for word in Words when word.length <= size)
    @isWord = (str) ->
      str in wordList

  inRange: (num) ->
    Util.inRange value: num, size: @size()

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

  generateNewGrid: ->
    @grid = for x in [0...@size()]
      for y in [0...@size()]
        @randomLetter()

  str: ->
    rows = for x in [0...@size()]
      for y in [0...@size()]
        @grid[y][x]
    rowStrings = (' ' + row.join(' | ') for row in rows)
    rowStrings.join '\n'
