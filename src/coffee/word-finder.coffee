WordFinder = @WordFinder = class

WordFinder.isWord = (params) ->
  {word, dictionary} = params
  word in dictionary
