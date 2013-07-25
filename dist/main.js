(function() {
  var Game;

  Game = this.Game = (function() {
    function _Class(options) {
      var grid, score, size, wordList, words;
      if (options == null) {
        options = {};
      }
      size = options.size, words = options.words, grid = options.grid;
      if (Util.isMatrixQuadratic(grid)) {
        size = Util.sizeMatrix(grid);
      } else {
        grid = void 0;
      }
      if (!Game.isValidSize(size)) {
        throw "Grid size not given";
      }
      grid || (grid = Util.generateGrid(size));
      wordList = Util.wordList({
        size: size,
        words: words
      });
      score = new Score({
        grid: grid,
        dictionary: words
      });
      this.size = function() {
        return size;
      };
      this.isWord = function(str) {
        return WordFinder.isWord({
          word: str,
          dictionary: wordList
        });
      };
      this.move = function(swapCoordinates) {
        return score.moveScore(swapCoordinates);
      };
      this.str = function() {
        return Util.printGrid(grid);
      };
      this.matrix = function() {
        return Util.matrix(grid);
      };
      this.set = function(coordinate) {
        var value, x, y;
        x = coordinate.x, y = coordinate.y, value = coordinate.value;
        return Util.setCoordinate({
          coordinates: grid,
          range: size,
          x: x,
          y: y,
          value: value
        });
      };
      this.get = function(coordinate) {
        var x, y;
        x = coordinate.x, y = coordinate.y;
        return Util.getCoordinate({
          coordinates: grid,
          x: x,
          y: y
        });
      };
    }

    _Class.prototype.inRange = function(num) {
      return Util.inRange({
        value: num,
        range: this.size()
      });
    };

    return _Class;

  })();

  Game.isValidSize = function(size) {
    if ((!size) || size < 0) {
      return false;
    } else {
      return true;
    }
  };

}).call(this);

(function() {
  var Score, VALUES,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  VALUES = {
    A: 1,
    B: 3,
    C: 3,
    D: 2,
    E: 1,
    F: 4,
    G: 2,
    H: 4,
    I: 1,
    J: 8,
    K: 5,
    L: 1,
    M: 3,
    N: 1,
    O: 1,
    P: 3,
    Q: 10,
    R: 1,
    S: 1,
    T: 1,
    U: 1,
    V: 4,
    W: 4,
    X: 8,
    Y: 4,
    Z: 10
  };

  Score = this.Score = (function() {
    function _Class(options) {
      var dictionary, grid;
      if (options == null) {
        options = {};
      }
      grid = options.grid, dictionary = options.dictionary;
      this.printGrid = function() {
        return Util.printGrid(grid);
      };
      this.matrix = function() {
        return Util.matrix(grid);
      };
      this.moveScore = function(swapCoordinates) {
        return Score.moveScore({
          grid: grid,
          dictionary: dictionary,
          swapCoordinates: swapCoordinates
        });
      };
      this.scoreWord = function(word) {
        if (__indexOf.call(dictionary, word) >= 0) {
          return Score.scoreWord(word);
        } else {
          return 0;
        }
      };
      this.words = function() {
        return Score.words({
          grid: grid,
          dictionary: dictionary
        });
      };
    }

    return _Class;

  })();

  Score.words = function(params) {
    var SIZE, dictionary, grid, word, words, words_on_xy, x, y, _i, _j, _k, _len, _ref;
    grid = params.grid, dictionary = params.dictionary;
    _ref = [[], grid.length], words = _ref[0], SIZE = _ref[1];
    for (x = _i = 0; 0 <= SIZE ? _i < SIZE : _i > SIZE; x = 0 <= SIZE ? ++_i : --_i) {
      for (y = _j = 0; 0 <= SIZE ? _j < SIZE : _j > SIZE; y = 0 <= SIZE ? ++_j : --_j) {
        words_on_xy = WordFinder.all({
          grid: grid,
          dictionary: dictionary,
          x: x,
          y: y,
          range: SIZE
        });
        for (_k = 0, _len = words_on_xy.length; _k < _len; _k++) {
          word = words_on_xy[_k];
          if (__indexOf.call(words, word) < 0) {
            words.push(word);
          }
        }
      }
    }
    return words;
  };

  Score.move = function(params) {
    var col1, col2, firstLetter, grid, row1, row2, secondLetter, _ref, _ref1, _ref2;
    grid = params.grid, (_ref = params.swapCoordinates, col1 = _ref.x1, row1 = _ref.y1, col2 = _ref.x2, row2 = _ref.y2);
    _ref1 = [grid[row1][col1], grid[row2][col2]], firstLetter = _ref1[0], secondLetter = _ref1[1];
    _ref2 = [secondLetter, firstLetter], grid[row1][col1] = _ref2[0], grid[row2][col2] = _ref2[1];
    return grid;
  };

  Score.moveScore = function(params) {
    var dictionary, grid, new_words, swapCoordinates, words_after_moving, words_before_moving;
    grid = params.grid, dictionary = params.dictionary, swapCoordinates = params.swapCoordinates;
    words_before_moving = this.words({
      grid: grid,
      dictionary: dictionary
    });
    this.move({
      grid: grid,
      swapCoordinates: swapCoordinates
    });
    words_after_moving = this.words({
      grid: grid,
      dictionary: dictionary
    });
    new_words = this.newWords({
      before: words_before_moving,
      after: words_after_moving
    });
    return {
      scoreMove: this.scoreWords(new_words),
      newWords: new_words
    };
  };

  Score.scoreWord = function(word) {
    var letter, score, _i, _len;
    score = 0;
    for (_i = 0, _len = word.length; _i < _len; _i++) {
      letter = word[_i];
      score += VALUES[letter];
    }
    return score;
  };

  Score.scoreWords = function(words) {
    var multiplier, score, word, _i, _len, _ref;
    _ref = [0, words.length], score = _ref[0], multiplier = _ref[1];
    for (_i = 0, _len = words.length; _i < _len; _i++) {
      word = words[_i];
      score += this.scoreWord(word);
    }
    return score * multiplier;
  };

  Score.newWords = function(params) {
    var new_word, words_after, words_before, _i, _len, _results;
    words_before = params.before, words_after = params.after;
    _results = [];
    for (_i = 0, _len = words_after.length; _i < _len; _i++) {
      new_word = words_after[_i];
      if (__indexOf.call(words_before, new_word) < 0) {
        _results.push(new_word);
      }
    }
    return _results;
  };

}).call(this);

(function() {
  var MIN_TILE_LENGTH, TileFinder, findMany, findOne,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  TileFinder = this.TileFinder = (function() {
    function _Class() {}

    return _Class;

  })();

  MIN_TILE_LENGTH = TileFinder.MIN_TILE_LENGTH = 2;

  findOne = function(params, funcDirectionLetter) {
    var col, grid, i, letter, range, row, tile, _i;
    grid = params.grid, range = params.range, col = params.x, row = params.y;
    tile = "";
    for (i = _i = 0; 0 <= range ? _i < range : _i > range; i = 0 <= range ? ++_i : --_i) {
      letter = funcDirectionLetter(i);
      if (letter != null) {
        tile += letter;
      }
    }
    if (tile.length === range) {
      return tile;
    }
  };

  findMany = function(params, function_to_match_tile) {
    var grid, offset, range, tile, tile_length, tiles, x, y, _i, _j;
    grid = params.grid, range = params.range, x = params.x, y = params.y;
    tiles = [];
    for (tile_length = _i = MIN_TILE_LENGTH; MIN_TILE_LENGTH <= range ? _i <= range : _i >= range; tile_length = MIN_TILE_LENGTH <= range ? ++_i : --_i) {
      for (offset = _j = 0; 0 <= tile_length ? _j < tile_length : _j > tile_length; offset = 0 <= tile_length ? ++_j : --_j) {
        tile = function_to_match_tile(tile_length, offset);
        if ((tile != null) && !(__indexOf.call(tiles, tile) >= 0)) {
          tiles.push(tile);
        }
      }
    }
    return tiles;
  };

  TileFinder.verticalOne = function(params) {
    var col, grid, range, row;
    grid = params.grid, range = params.range, col = params.x, row = params.y;
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row + i]) != null ? _ref[col] : void 0;
    });
  };

  TileFinder.horizontalOne = function(params) {
    var col, grid, range, row;
    grid = params.grid, range = params.range, col = params.x, row = params.y;
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.diagonalOne_upperLeft_to_lowerRight = function(params) {
    var col, grid, range, row;
    grid = params.grid, range = params.range, col = params.x, row = params.y;
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row + i]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.diagonalOne_lowerLeft_to_upperRight = function(params) {
    var col, grid, range, row;
    grid = params.grid, range = params.range, col = params.x, row = params.y;
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row - i]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.verticalTiles = function(params) {
    var grid, range, x, y;
    grid = params.grid, range = params.range, x = params.x, y = params.y;
    return findMany(params, function(tile_length, offset) {
      return TileFinder.verticalOne({
        grid: grid,
        x: x,
        y: y - offset,
        range: tile_length
      });
    });
  };

  TileFinder.horizontalTiles = function(params) {
    var grid, range, x, y;
    grid = params.grid, range = params.range, x = params.x, y = params.y;
    return findMany(params, function(tile_length, offset) {
      return TileFinder.horizontalOne({
        grid: grid,
        x: x - offset,
        y: y,
        range: tile_length
      });
    });
  };

  TileFinder.diagonalTiles_upperLeft_to_lowerRight = function(params) {
    var grid, range, x, y;
    grid = params.grid, range = params.range, x = params.x, y = params.y;
    return findMany(params, function(tile_length, offset) {
      return TileFinder.diagonalOne_upperLeft_to_lowerRight({
        grid: grid,
        x: x - offset,
        y: y - offset,
        range: tile_length
      });
    });
  };

  TileFinder.diagonalTiles_lowerLeft_to_upperRight = function(params) {
    var grid, range, x, y;
    grid = params.grid, range = params.range, x = params.x, y = params.y;
    return findMany(params, function(tile_length, offset) {
      return TileFinder.diagonalOne_lowerLeft_to_upperRight({
        grid: grid,
        x: x - offset,
        y: y + offset,
        range: tile_length
      });
    });
  };

  TileFinder.all = function(params) {
    var allTiles, finderTiles, tile, tiles, _i, _j, _len, _len1, _ref;
    allTiles = [];
    _ref = [this.verticalTiles, this.horizontalTiles, this.diagonalTiles_upperLeft_to_lowerRight, this.diagonalTiles_lowerLeft_to_upperRight];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      finderTiles = _ref[_i];
      tiles = finderTiles(params);
      for (_j = 0, _len1 = tiles.length; _j < _len1; _j++) {
        tile = tiles[_j];
        if (__indexOf.call(allTiles, tile) < 0) {
          allTiles.push(tile);
        }
      }
    }
    return allTiles;
  };

}).call(this);

(function() {
  var Tile, tileCounts;

  Tile = this.Tile = (function() {
    function _Class() {}

    return _Class;

  })();

  tileCounts = {
    A: 9,
    B: 2,
    C: 2,
    D: 4,
    E: 12,
    F: 2,
    G: 3,
    H: 2,
    I: 9,
    J: 1,
    K: 1,
    L: 4,
    M: 2,
    N: 6,
    O: 8,
    P: 2,
    Q: 1,
    R: 6,
    S: 4,
    T: 6,
    U: 4,
    V: 2,
    W: 2,
    X: 1,
    Y: 2,
    Z: 1
  };

  Tile.total = function() {
    var count, letter, totalTiles;
    totalTiles = 0;
    for (letter in tileCounts) {
      count = tileCounts[letter];
      totalTiles += count;
    }
    return totalTiles;
  };

  Tile.alphabet = function() {
    var letter;
    return ((function() {
      var _results;
      _results = [];
      for (letter in tileCounts) {
        _results.push(letter);
      }
      return _results;
    })()).sort();
  };

  Tile.randomLetter = function() {
    var letter, randomNumber, x, _i, _len, _ref;
    randomNumber = Math.ceil(Math.random() * this.total());
    x = 1;
    _ref = this.alphabet();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      letter = _ref[_i];
      x += tileCounts[letter];
      if (x > randomNumber) {
        return letter;
      }
    }
  };

}).call(this);

(function() {
  var Util;

  Util = this.Util = (function() {
    function _Class() {}

    return _Class;

  })();

  Util.isInteger = function(num) {
    return num === Math.round(num);
  };

  Util.inRange = function(params) {
    var range, value, x, y;
    value = params.value, range = params.range, x = params.x, y = params.y;
    if (value != null) {
      return (this.isInteger(value)) && (0 <= value && value < range);
    } else if ((x != null) && (y != null)) {
      return (this.inRange({
        value: x,
        range: range
      })) && (this.inRange({
        value: y,
        range: range
      }));
    }
  };

  Util.setCoordinate = function(params) {
    var coordinates, range, value, x, y;
    coordinates = params.coordinates, range = params.range, x = params.x, y = params.y, value = params.value;
    coordinates[x] || (coordinates[x] = []);
    if (this.inRange({
      value: x,
      range: range
    }) && this.inRange({
      value: y,
      range: range
    })) {
      coordinates[x][y] = value;
    } else {
      coordinates[x][y] = void 0;
    }
    return !!coordinates[x][y];
  };

  Util.getCoordinate = function(params) {
    var coordinates, x, y;
    coordinates = params.coordinates, x = params.x, y = params.y;
    return coordinates[x][y];
  };

  Util.generateGrid = function(size) {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= size ? _i < size : _i > size; x = 0 <= size ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= size ? _j < size : _j > size; y = 0 <= size ? ++_j : --_j) {
          _results1.push(Tile.randomLetter());
        }
        return _results1;
      })());
    }
    return _results;
  };

  Util.printGrid = function(grid) {
    var row, rowStrings, rows;
    rows = this.matrix(grid);
    rowStrings = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = rows.length; _i < _len; _i++) {
        row = rows[_i];
        _results.push(' ' + row.join(' | '));
      }
      return _results;
    })();
    return rowStrings.join('\n');
  };

  Util.matrix = function(grid) {
    var x, y, _i, _ref, _results;
    _results = [];
    for (x = _i = 0, _ref = grid.length; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (y = _j = 0, _ref1 = grid[x].length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          _results1.push(grid[x][y]);
        }
        return _results1;
      })());
    }
    return _results;
  };

  Util.wordList = function(params) {
    var size, word, words, _i, _len, _ref, _results;
    size = params.size, words = params.words;
    _results = [];
    for (_i = 0, _len = words.length; _i < _len; _i++) {
      word = words[_i];
      if ((TileFinder.MIN_TILE_LENGTH <= (_ref = word.length) && _ref <= size)) {
        _results.push(word);
      }
    }
    return _results;
  };

  Util.isMatrixQuadratic = function(matrix) {
    var row, _i, _len;
    if (!matrix) {
      return false;
    }
    for (_i = 0, _len = matrix.length; _i < _len; _i++) {
      row = matrix[_i];
      if (matrix.length !== row.length) {
        return false;
      }
    }
    return true;
  };

  Util.sizeMatrix = function(matrix) {
    if (this.isMatrixQuadratic(matrix)) {
      return matrix.length;
    } else {
      return void 0;
    }
  };

  Util.isValidSwapCoordinates = function(params) {
    var isMovingDiagonaly, isMovingHorizontaly, isMovingVerticaly, isValid, range, x1, x2, y1, y2;
    x1 = params.x1, y1 = params.y1, x2 = params.x2, y2 = params.y2, range = params.range;
    isMovingHorizontaly = Math.abs(x2 - x1) === 1;
    isMovingVerticaly = Math.abs(y2 - y1) === 1;
    isMovingDiagonaly = isMovingHorizontaly && isMovingVerticaly;
    isValid = isMovingDiagonaly ? false : isMovingHorizontaly || isMovingVerticaly;
    if (isValid && (range != null)) {
      return this.inRange({
        x: x1,
        y: y1,
        size: range
      }) && this.inRange({
        x: x2,
        y: y2,
        size: range
      });
    } else {
      return isValid;
    }
  };

}).call(this);

(function() {
  var WordFinder,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  WordFinder = this.WordFinder = (function() {
    function _Class() {}

    return _Class;

  })();

  WordFinder.isWord = function(params) {
    var dictionary, word;
    word = params.word, dictionary = params.dictionary;
    return __indexOf.call(dictionary, word) >= 0;
  };

  WordFinder.all = function(params) {
    var all_tiles, dictionary, grid, range, tile, x, y, _i, _len, _results;
    grid = params.grid, dictionary = params.dictionary, range = params.range, x = params.x, y = params.y;
    all_tiles = TileFinder.all(params);
    _results = [];
    for (_i = 0, _len = all_tiles.length; _i < _len; _i++) {
      tile = all_tiles[_i];
      if (this.isWord({
        word: tile,
        dictionary: dictionary
      })) {
        _results.push(tile);
      }
    }
    return _results;
  };

}).call(this);
