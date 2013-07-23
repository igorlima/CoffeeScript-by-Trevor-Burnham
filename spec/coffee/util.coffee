describe "Util class", ->

  it "3 should be an integer", ->
    expect( Util.isInteger 3 ).toBe true
  
  it "1.1 should NOT be an integer", ->
    expect( Util.isInteger 1.1 ).toBe false

  it "3 should be in range if the size is 4", ->
    expect( Util.inRange value: 3, size: 4 ).toBe true

  it "4 should NOT be in range if the size is 4", ->
    expect( Util.inRange value: 4, size: 4 ).not.toBe true

