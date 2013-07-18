
describe "Grid class", ->

  describe "Methods util", ->
    generic_grid = new Grid size: 4

    it "An exception will be raised if a size is not given", ->
      expect( -> new Grid() ).toThrow()

    it "An exception will be raised if a size is 0", ->
      expect( -> new Grid size: 0 ).toThrow()

    it "An exception will be raised if a size is less than 0", ->
      expect( -> new Grid size: -1 ).toThrow()

    it "4 should NOT be in range if the grid has size 4", ->
      expect( generic_grid.inRange 4 ).not.toBe true

    it "3 should be in range if the grid has size 4", ->
      expect( generic_grid.inRange 3 ).toBe true

    it "1.1 should NOT be an integer", ->
      expect( generic_grid.isInteger 1.1 ).not.toBe true

    it "3.1 should NOT be in range, because it's NOT an integer", ->
      expect( generic_grid.inRange 3.1 ).not.toBe true

  describe "5x5 project", ->
    grid = new Grid size: 5

    it "should be a size 5", ->
      expect(grid.size()).toBe 5
