WordFinder = Scrabble.WordFinder

describe "WordFinder class", ->

  wordList = ['DOES', 'DO', 'THINK', 'BATH', 'DOGS', 'BOSS', 'DOG', 'SEGA']
  grid = [
    ['B', 'D', 'A', 'A']
    ['D', 'O', 'G', 'S']
    ['A', 'E', 'S', 'A']
    ['S', 'S', 'A', 'S']
  ]

  it "the word 'DOES' should be a word from the dictionary of ['DOES', 'DO', 'THINK', 'BATH'] ", ->
    expect( WordFinder.isWord word: 'DOES', dictionary: ['DOES', 'DO', 'THINK', 'BATH'] ).toBe true

  it "the word 'LIKE' should NOT be a word from the dictionary of ['DOES', 'DO', 'THINK', 'BATH'] ", ->
    expect( WordFinder.isWord word: 'LIKE', dictionary: ['DOES', 'DO', 'THINK', 'BATH'] ).toBe false

  it "the grid should contain the word list ['DOES', 'DOGS', 'BOSS', 'DOG', 'DO'] on (x:1, y:1)", ->
    all_words = WordFinder.all grid: grid, dictionary: wordList, range: 4, x: 1, y: 1
    expect( all_words ).toContain 'DOES'
    expect( all_words ).toContain 'DOGS'
    expect( all_words ).toContain 'BOSS'
    expect( all_words ).toContain 'DOG'
    expect( all_words ).toContain 'DO'

  it "the word 'SEGA' should be in list of words (x:1, y:1)", ->
    all_words = WordFinder.all grid: grid, dictionary: wordList, range: 4, x: 2, y: 1
    expect( all_words ).toContain 'SEGA'
