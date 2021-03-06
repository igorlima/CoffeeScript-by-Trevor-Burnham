Tile = @Scrabble.Tile = class
  
# Probabilities are taken from Scrabble, except that there are no blanks
# See http://www.zyzzyva.net/wordlists.shtml
tileCounts =
  A: 9, B: 2, C: 2, D: 4, E: 12, F: 2, G: 3, H: 2, I: 9, J: 1, K: 1, L: 4
  M: 2, N: 6, O: 8, P: 2, Q: 1,  R: 6, S: 4, T: 6, U: 4, V: 2, W: 2, X: 1
  Y: 2, Z: 1

totalTiles = 0
totalTiles += count for letter, count of tileCounts

alphabet = (letter for letter of tileCounts).sort()

Tile.total = ->
  totalTiles

Tile.alphabet = ->
  alphabet[0...] #do a copy

Tile.randomLetter = ->
  randomNumber = Math.ceil Math.random() * totalTiles
  x = 1
  for letter in alphabet
    x += tileCounts[letter]
    return letter if x > randomNumber
