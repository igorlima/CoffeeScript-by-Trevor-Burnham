describe "Score class", ->
  score = undefined

  beforeEach ->
    score = new Score
      grid: [
        ['D', 'B', 'O', 'A']
        ['D', 'O', 'G', 'S']
        ['A', 'E', 'S', 'A']
        ['S', 'S', 'I', 'S']
      ]
      dictionary: ['DOES', 'DO', 'THINK', 'BATH', 'DOGS', 'BOSS', 'DOG', 'SEGA']


  it "the printing of grid should be a square 4x4", ->
    grid_string_rows = score.printGrid().split '\n'
    expect( grid_string_rows[0] ).toMatch "D [|] B [|] O [|] A"
    expect( grid_string_rows[1] ).toMatch "D [|] O [|] G [|] S"
    expect( grid_string_rows[2] ).toMatch "A [|] E [|] S [|] A"
    expect( grid_string_rows[3] ).toMatch "S [|] S [|] I [|] S"

  it "the letter 'B' should move from (x:1, y:0) to (x:0, y:0)", ->
    score.move x1: 1, y1: 0, x2: 0, y2: 0
    matrix = score.matrix()
    expect( matrix[0] ).toMatch ['B', 'D', 'O', 'A']
    expect( matrix[1] ).toMatch ['D', 'O', 'G', 'S']
    expect( matrix[2] ).toMatch ['A', 'E', 'S', 'A']
    expect( matrix[3] ).toMatch ['S', 'S', 'I', 'S']

  it "the letter 'G' should move from (x:2, y:1) to (x:2, y:2)", ->
    score.move x1: 2, y1: 1, x2: 2, y2: 2
    matrix = score.matrix()
    expect( matrix[0] ).toMatch ['D', 'B', 'O', 'A']
    expect( matrix[1] ).toMatch ['D', 'O', 'S', 'S']
    expect( matrix[2] ).toMatch ['A', 'E', 'G', 'A']
    expect( matrix[3] ).toMatch ['S', 'S', 'I', 'S']

  it "the point of 'DOES' should be 5", ->
    expect( Score.scoreWord 'DOES' ).toBe 5

  it "the point of 'CLOUD' from the object 'score' should be 0, because this word doesn't belong the dictionary", ->
    expect( score.scoreWord 'CLOUD' ).toBe 0
