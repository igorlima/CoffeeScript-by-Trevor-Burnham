describe "Score class", ->
  score = undefined

  beforeEach ->
    score = new Score grid: [
      ['B', 'D', 'O', 'A']
      ['D', 'O', 'G', 'S']
      ['A', 'E', 'S', 'A']
      ['S', 'S', 'I', 'S']
    ]

  it "the letter 'D' should move from (x:1, y:0) to (x:0, y:0)", ->
    score.move x1: 1, y1: 0, x2: 0, y2: 0
    grid_string_rows = score.printGrid().split '\n'

    expect( grid_string_rows[0] ).toMatch "D [|] B [|] O [|] A"
    expect( grid_string_rows[1] ).toMatch "D [|] O [|] G [|] S"
    expect( grid_string_rows[2] ).toMatch "A [|] E [|] S [|] A"
    expect( grid_string_rows[3] ).toMatch "S [|] S [|] I [|] S"

  it "the letter 'G' should move from (x:2, y:1) to (x:2, y:2)", ->
    score.move x1: 2, y1: 1, x2: 2, y2: 2
    grid_string_rows = score.printGrid().split '\n'

    expect( grid_string_rows[0] ).toMatch "B [|] D [|] O [|] A"
    expect( grid_string_rows[1] ).toMatch "D [|] O [|] S [|] S"
    expect( grid_string_rows[2] ).toMatch "A [|] E [|] G [|] A"
    expect( grid_string_rows[3] ).toMatch "S [|] S [|] I [|] S"
