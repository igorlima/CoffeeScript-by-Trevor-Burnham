describe "5x5 project", ->
  grid = new Grid size: 5

  it "should be a size 5", ->
    expect(grid.size()).toBe 5
