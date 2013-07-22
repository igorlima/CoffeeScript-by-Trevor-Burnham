
describe "Grid class", ->

  describe "Methods util: inRange / isInteger", ->
    generic_grid = new Grid size: 4

    it "an exception will be raised if a size is not given", ->
      expect( -> new Grid() ).toThrow()

    it "an exception will be raised if a size is 0", ->
      expect( -> new Grid size: 0 ).toThrow()

    it "an exception will be raised if a size is less than 0", ->
      expect( -> new Grid size: -1 ).toThrow()

    it "4 should NOT be in range if the grid has size 4", ->
      expect( generic_grid.inRange 4 ).not.toBe true

    it "3 should be in range if the grid has size 4", ->
      expect( generic_grid.inRange 3 ).toBe true

    it "1.1 should NOT be an integer", ->
      expect( generic_grid.isInteger 1.1 ).not.toBe true

    it "3.1 should NOT be in range, because it's NOT an integer", ->
      expect( generic_grid.inRange 3.1 ).not.toBe true

    it "the word 'DOES' should be a word", ->
      expect( generic_grid.isWord 'DOES' ).toBe true

    it "the word 'THINKING' should NOT be a word from a grid which has a size 4", ->
      expect( generic_grid.isWord 'THINKING' ).not.toBe true

    it "the total face point value should be 98", ->
      expect( generic_grid.totalTiles() ).toBe 98

    it "the alphabet should be sorted from A to Z", ->
      expect( generic_grid.alphabet() ).toEqual [
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'
        'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X'
        'Y', 'Z'
      ]

    it "a random letter should be a letter from the alphabet", ->
      expect( generic_grid.alphabet() ).toContain generic_grid.randomLetter()

  describe "5x5 project", ->
    grid = new Grid size: 5

    it "should be a size 5", ->
      expect(grid.size()).toBe 5

    it "coordinates (2,3) should be set", ->
      expect(grid.set x: 2, y: 3, value: 'a').toBe true
      expect(grid.get x: 2, y: 3).toBe 'a'
