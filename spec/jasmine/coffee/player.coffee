{Player, Board} = Scrabble

describe "Player class", ->
  player = undefined

  beforeEach ->
    player = new Player name: 'Petter'

  it "the player should have a name", ->
    expect( player.name() ).toBeDefined()

  it "the player should init with score as 0", ->
    expect( player.score() ).toBe 0

  it "the player should init with score count as 0", ->
    expect( player.moveCount() ).toBe 0

  it "the player should NOT increase the score if try to move without pass any paramert", ->
    player.move()
    expect( player.score() ).toBe 0

  it "the player should NOT increase the move count if try to move without pass any paramert", ->
    player.move()
    expect( player.moveCount() ).toBe 0

  it "the player should return undefined if try to move without pass any paramert", ->
    expect( player.move() ).not.toBeDefined()

  describe "the moviment of player", ->
    moveScore = swapCoordinates = board = undefined

    beforeEach ->
      board = new Board
        words: ['DO', 'DID', 'GET']
        grid: [
          ['G', 'D', 'A']
          ['O', 'E', 'I']
          ['T', 'C', 'D']
        ]
      swapCoordinates = x1: 1, y1: 0, x2: 2, y2: 0
      moveScore = player.move {board, swapCoordinates}

    it "the player should increase the move count after a legal moviment", ->
      expect( player.moveCount() ).toBe 1

    it "the player should increase the score after match a word", ->
      expect( player.score() ).toBeGreaterThan 0

    it "the player should return a result object after a legal moviment", ->
      expect( moveScore ).toEqual( jasmine.any Object )

    it "", ->

