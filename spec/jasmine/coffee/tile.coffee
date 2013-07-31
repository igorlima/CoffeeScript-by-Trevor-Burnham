Tile = Scrabble.Tile

describe "Tile class", ->

  it "the tile total should be 98", ->
    expect( Tile.total() ).toBe 98

  it "the alphabet should be sorted from A to Z", ->
    expect( Tile.alphabet() ).toEqual [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'
      'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X'
      'Y', 'Z'
    ]

  it "a random letter should be a letter from the alphabet", ->
    expect( Tile.alphabet() ).toContain Tile.randomLetter()
