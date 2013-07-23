describe "Util class", ->
  
  it "1.1 should NOT be an integer", ->
    expect( Util.isInteger 1.1 ).toBe false

  #it "4 should NOT be in range if the size is 4", ->
  #  expect( Util.inRange value: 4, size: 4 ).not.toBe true

