describe "WordFinder class", ->

  it "the word 'DOES' should be a word from the dictionary of ['DOES', 'DO', 'THINK', 'BATH'] ", ->
    wordList = ['DOES', 'DO', 'THINK', 'BATH']
    expect( WordFinder.isWord word: 'DOES', dictionary: wordList ).toBe true

  it "the word 'LIKE' should NOT be a word from the dictionary of ['DOES', 'DO', 'THINK', 'BATH'] ", ->
    wordList = ['DOES', 'DO', 'THINK', 'BATH']
    expect( WordFinder.isWord word: 'LIKE', dictionary: wordList ).toBe false
