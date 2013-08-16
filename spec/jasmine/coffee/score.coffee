{Util, Score} = Scrabble

describe "Score class", ->
  score = grid = dictionary = undefined

  beforeEach ->
    grid = [
      ['D', 'B', 'O', 'A']
      ['D', 'O', 'G', 'S']
      ['A', 'E', 'S', 'A']
      ['S', 'S', 'I', 'S']
    ]
    dictionary = ['DOES', 'DO', 'THINK', 'BATH', 'DOGS', 'BOSS', 'DOG', 'SEGA', 'OGA']
    score = new Score {grid, dictionary}

  it "the letter 'B' should move from (x:1, y:0) to (x:0, y:0)", ->
    swapCoordinates = x1: 1, y1: 0, x2: 0, y2: 0
    Score.move {grid, swapCoordinates}
    matrix = Util.matrix grid
    expect( matrix[0] ).toMatch ['B', 'D', 'O', 'A']
    expect( matrix[1] ).toMatch ['D', 'O', 'G', 'S']
    expect( matrix[2] ).toMatch ['A', 'E', 'S', 'A']
    expect( matrix[3] ).toMatch ['S', 'S', 'I', 'S']

  it "the letter 'G' should move from (x:2, y:1) to (x:2, y:2)", ->
    swapCoordinates = x1: 2, y1: 1, x2: 2, y2: 2
    Score.move {grid, swapCoordinates}
    matrix = Util.matrix grid
    expect( matrix[0] ).toMatch ['D', 'B', 'O', 'A']
    expect( matrix[1] ).toMatch ['D', 'O', 'S', 'S']
    expect( matrix[2] ).toMatch ['A', 'E', 'G', 'A']
    expect( matrix[3] ).toMatch ['S', 'S', 'I', 'S']

  it "the letter 'G' on (x:2, y:1) should move down", ->
    swapCoordinates = x1: 2, y1: 1, x2: 2, y2: 2
    expect( Score.move {grid, swapCoordinates} ).toBe true

  it "the letter 'S' should NOT move from (x:3, y:3) to (x:3, y:4), because this coordinate does NOT exist in the grid", ->
    swapCoordinates = x1: 3, y1: 3, x2: 3, y2: 4
    Score.move {grid, swapCoordinates}
    matrix = Util.matrix grid
    expect( matrix[0] ).toMatch ['D', 'B', 'O', 'A']
    expect( matrix[1] ).toMatch ['D', 'O', 'G', 'S']
    expect( matrix[2] ).toMatch ['A', 'E', 'S', 'A']
    expect( matrix[3] ).toMatch ['S', 'S', 'I', 'S']

  it "the letter 'S' on (x:3, y:3) should NOT move down", ->
    swapCoordinates = x1: 3, y1: 3, x2: 3, y2: 4
    expect( Score.move {grid, swapCoordinates} ).toBe false

  it "the point of 'DOES' should be 5", ->
    expect( Score.scoreWord 'DOES' ).toBe 5

  it "the point of 'CLOUD' from the object 'score' should be 0, because this word doesn't belong the dictionary", ->
    expect( score.scoreWord 'CLOUD' ).toBe 0

  it "the words from the grid should contain ['DO', 'DOG', 'DOGS', 'SEGA']", ->
    words = Score.words {grid, dictionary}
    expect( words ).toContain 'DO'
    expect( words ).toContain 'DOG'
    expect( words ).toContain 'DOGS'
    expect( words ).toContain 'SEGA'

  it "the words from the grid should contain ['DO', 'DOG', 'DOGS', 'SEGA']", ->
    words = score.words()
    expect( words ).toContain 'DO'
    expect( words ).toContain 'DOG'
    expect( words ).toContain 'DOGS'
    expect( words ).toContain 'SEGA'

  it "the words 'THINK' and 'BATH' should be new words", ->
    words_before_moving = ['DOES', 'DO', 'DOGS', 'BOSS']
    words_after_moving = ['DOES', 'DO', 'THINK', 'BATH']
    new_words = Score.newWords before: words_before_moving, after: words_after_moving
    expect( new_words ).toContain 'THINK'
    expect( new_words ).toContain 'BATH'

  it "the words 'DOES' and 'DO' should NOT be new words, because these words were already in the list", ->
    words_before_moving = ['DOES', 'DO', 'DOGS', 'BOSS']
    words_after_moving = ['DOES', 'DO', 'THINK', 'BATH']
    new_words = Score.newWords before: words_before_moving, after: words_after_moving
    expect( new_words ).not.toContain 'DOES'
    expect( new_words ).not.toContain 'DO'

  it "the new words 'THINK' and 'BATH' should be scored with 42 points
      THINK has 12 points
      BATH has 9 points
      two words have the MULTIPLIER as 2
      Then the total points should be (12+9)*2 = 42
      ", ->
    new_words = ['THINK', 'BATH']
    expect( Score.scoreWords new_words ).toBe 42

  it "the new words should NOT contain 'DOGS', after moving letter 'G' from (x:2, y:1) to (x:2, y:2).
      Because this word already existed", ->
    {moveScore, newWords} = score.moveScore x1: 2, y1: 1, x2: 2, y2: 2
    expect( newWords ).not.toContain 'DOGS'

  it "the new words should contain 'OGA', after moving letter 'G' from (x:3, y:0) to (x:3, y:1)", ->
    {moveScore, newWords} = score.moveScore x1: 3, y1: 0, x2: 3, y2: 1
    expect( newWords ).toContain 'OGA'

  it "the result of moving moving down the letter 'S' on (x:3, y:3) SHOULD NOT be defined, because it is NOT a legal moving", ->
    expect( score.moveScore x1: 3, y1: 3, x2: 3, y2: 3 ).not.toBeDefined()

  describe "moving from (x:1, y:0) to (x:0, y:0)", ->
    moveScore = newWords = undefined
    beforeEach ->
      swapCoordinates = x1: 1, y1: 0, x2: 0, y2: 0
      {moveScore, newWords} = Score.moveScore {grid, swapCoordinates, dictionary}

    it "it SHOULD have 'BOSS' as a new word", ->
      expect( newWords ).toContain 'BOSS'

    it "it SHOULD have 'DOES' as a new word", ->
      expect( newWords ).toContain 'DOES'

  describe "printing a grid 4x4", ->
    grid_string_rows = undefined
    beforeEach ->
      grid_string_rows = score.printGrid().split '\n'

    it "first line SHOULD be 'D | B | O | A'", ->
      expect( grid_string_rows[0] ).toMatch "D [|] B [|] O [|] A"

    it "second line SHOULD be 'D | O | G | S'", ->
      expect( grid_string_rows[1] ).toMatch "D [|] O [|] G [|] S"

    it "third line SHOULD be 'A | E | S | A'", ->
      expect( grid_string_rows[2] ).toMatch "A [|] E [|] S [|] A"

    it "forth line SHOULD be 'S | S | I | S'", ->
      expect( grid_string_rows[3] ).toMatch "S [|] S [|] I [|] S"
