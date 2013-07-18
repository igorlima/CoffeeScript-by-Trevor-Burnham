
describe "Grid class", ->

  it "An exception will be raised if a size is not given", ->
    expect( -> new Grid() ).toThrow()

  it "An exception will be raised if a size is 0", ->
    expect( -> new Grid size: 0 ).toThrow()

  it "An exception will be raised if a size is less than 0", ->
    expect( -> new Grid size: -1 ).toThrow()

  it "4 should NOT be in range if the grid has size 4", ->
    grid = new Grid size: 4
    expect( grid.inRange 4 ).not.toBe true

  it "3 should be in range if the grid has size 4", ->
    grid = new Grid size: 4
    expect( grid.inRange 3 ).toBe true

  describe "5x5 project", ->
    grid = new Grid size: 5

    it "should be a size 5", ->
      expect(grid.size()).toBe 5
