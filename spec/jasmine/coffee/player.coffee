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

  describe "move from (1, 0) to (2, 0)", ->
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

    it "list of words SHOULD contain the word 'DID'", ->
      expect( player.words() ).toContain 'DID'

    describe "move from (1, 1) to (0, 1)", ->
      beforeEach ->
        swapCoordinates = x1: 1, y1: 1, x2: 0, y2: 1
        player.move {board, swapCoordinates}

      it "list of words SHOULD contain the word 'GET'", ->
        expect( player.words() ).toContain 'GET'

      it "list of words SHOULD have two elements", ->
        expect( player.words().length ).toBe 2

    describe "invalidily trying to modify the list of wors", ->
      words = undefined
      beforeEach ->
        words = player.words()
        words.push 'THINK'

      it "list of words SHOULD not contain the word 'THINK'", ->
        expect( player.words() ).not.toContain 'THINK'

      it "the list of words SHOULD be a different instance of array on each call", ->
        expect( player.words() ).not.toBe words
