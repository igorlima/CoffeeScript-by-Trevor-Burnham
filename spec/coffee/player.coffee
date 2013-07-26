Player = Scrabble.Player

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