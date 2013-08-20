(function() {
  this.Scrabble = (function() {
    function _Class() {}

    _Class.defaultView = function() {
      return {
        PLAYER: {
          ONE: {
            SCORE: 'p1score',
            NAME: 'p1name',
            MSG: 'p1message'
          },
          TWO: {
            SCORE: 'p2score',
            NAME: 'p2name',
            MSG: 'p2message'
          }
        },
        MESSAGE: 'message',
        NOTICE: 'notice',
        GRID: 'grid'
      };
    };

    return _Class;

  })();

}).call(this);

(function() {
  var Tile, alphabet, count, letter, tileCounts, totalTiles;

  Tile = this.Scrabble.Tile = (function() {
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

  totalTiles = 0;

  for (letter in tileCounts) {
    count = tileCounts[letter];
    totalTiles += count;
  }

  alphabet = ((function() {
    var _results;
    _results = [];
    for (letter in tileCounts) {
      _results.push(letter);
    }
    return _results;
  })()).sort();

  Tile.total = function() {
    return totalTiles;
  };

  Tile.alphabet = function() {
    return alphabet.slice(0);
  };

  Tile.randomLetter = function() {
    var randomNumber, x, _i, _len;
    randomNumber = Math.ceil(Math.random() * totalTiles);
    x = 1;
    for (_i = 0, _len = alphabet.length; _i < _len; _i++) {
      letter = alphabet[_i];
      x += tileCounts[letter];
      if (x > randomNumber) {
        return letter;
      }
    }
  };

}).call(this);

(function() {
  var MIN_TILE_LENGTH, TileFinder, findMany, findOne,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  TileFinder = this.Scrabble.TileFinder = (function() {
    function _Class() {}

    return _Class;

  })();

  MIN_TILE_LENGTH = TileFinder.MIN_TILE_LENGTH = 2;

  findOne = function(_arg, funcDirectionLetter) {
    var col, grid, i, letter, range, row, tile, _i;
    grid = _arg.grid, range = _arg.range, col = _arg.x, row = _arg.y;
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

  findMany = function(_arg, function_to_match_tile) {
    var grid, offset, range, tile, tile_length, tiles, x, y, _i, _j;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
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

  TileFinder.verticalOne = function(_arg) {
    var col, grid, params, range, row;
    grid = _arg.grid, range = _arg.range, col = _arg.x, row = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: col,
      y: row
    };
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row + i]) != null ? _ref[col] : void 0;
    });
  };

  TileFinder.horizontalOne = function(_arg) {
    var col, grid, params, range, row;
    grid = _arg.grid, range = _arg.range, col = _arg.x, row = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: col,
      y: row
    };
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.diagonalOne_upperLeft_to_lowerRight = function(_arg) {
    var col, grid, params, range, row;
    grid = _arg.grid, range = _arg.range, col = _arg.x, row = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: col,
      y: row
    };
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row + i]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.diagonalOne_lowerLeft_to_upperRight = function(_arg) {
    var col, grid, params, range, row;
    grid = _arg.grid, range = _arg.range, col = _arg.x, row = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: col,
      y: row
    };
    return findOne(params, function(i) {
      var _ref;
      return (_ref = grid[row - i]) != null ? _ref[col + i] : void 0;
    });
  };

  TileFinder.verticalTiles = function(_arg) {
    var grid, params, range, x, y;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: x,
      y: y
    };
    return findMany(params, function(tile_length, offset) {
      return TileFinder.verticalOne({
        grid: grid,
        x: x,
        y: y - offset,
        range: tile_length
      });
    });
  };

  TileFinder.horizontalTiles = function(_arg) {
    var grid, params, range, x, y;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: x,
      y: y
    };
    return findMany(params, function(tile_length, offset) {
      return TileFinder.horizontalOne({
        grid: grid,
        x: x - offset,
        y: y,
        range: tile_length
      });
    });
  };

  TileFinder.diagonalTiles_upperLeft_to_lowerRight = function(_arg) {
    var grid, params, range, x, y;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: x,
      y: y
    };
    return findMany(params, function(tile_length, offset) {
      return TileFinder.diagonalOne_upperLeft_to_lowerRight({
        grid: grid,
        x: x - offset,
        y: y - offset,
        range: tile_length
      });
    });
  };

  TileFinder.diagonalTiles_lowerLeft_to_upperRight = function(_arg) {
    var grid, params, range, x, y;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
    params = {
      grid: grid,
      range: range,
      x: x,
      y: y
    };
    return findMany(params, function(tile_length, offset) {
      return TileFinder.diagonalOne_lowerLeft_to_upperRight({
        grid: grid,
        x: x - offset,
        y: y + offset,
        range: tile_length
      });
    });
  };

  TileFinder.all = function(_arg) {
    var allTiles, finderTiles, grid, range, tile, tiles, x, y, _i, _j, _len, _len1, _ref;
    grid = _arg.grid, range = _arg.range, x = _arg.x, y = _arg.y;
    allTiles = [];
    _ref = [this.verticalTiles, this.horizontalTiles, this.diagonalTiles_upperLeft_to_lowerRight, this.diagonalTiles_lowerLeft_to_upperRight];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      finderTiles = _ref[_i];
      tiles = finderTiles({
        grid: grid,
        range: range,
        x: x,
        y: y
      });
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
  var Scrabble, TileFinder, WordFinder,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Scrabble = this.Scrabble;

  TileFinder = Scrabble.TileFinder;

  WordFinder = Scrabble.WordFinder = (function() {
    function _Class() {}

    _Class.isWord = function(_arg) {
      var dictionary, word;
      word = _arg.word, dictionary = _arg.dictionary;
      return __indexOf.call(dictionary, word) >= 0;
    };

    _Class.all = function(_arg) {
      var all_tiles, dictionary, grid, range, tile, x, y, _i, _len, _results;
      grid = _arg.grid, dictionary = _arg.dictionary, range = _arg.range, x = _arg.x, y = _arg.y;
      all_tiles = TileFinder.all({
        grid: grid,
        dictionary: dictionary,
        range: range,
        x: x,
        y: y
      });
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

    return _Class;

  })();

}).call(this);

(function() {
  var Message, Scrabble, Tile, TileFinder, Util;

  Scrabble = this.Scrabble;

  Tile = Scrabble.Tile, TileFinder = Scrabble.TileFinder;

  Util = Scrabble.Util = (function() {
    function _Class() {}

    return _Class;

  })();

  Util.isInteger = function(num) {
    return num === Math.round(num);
  };

  Util.inRange = function(_arg) {
    var range, value, x, y;
    value = _arg.value, range = _arg.range, x = _arg.x, y = _arg.y;
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

  Util.setCoordinate = function(_arg) {
    var coordinates, range, value, x, y;
    coordinates = _arg.coordinates, range = _arg.range, x = _arg.x, y = _arg.y, value = _arg.value;
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

  Util.getCoordinate = function(_arg) {
    var coordinates, x, y;
    coordinates = _arg.coordinates, x = _arg.x, y = _arg.y;
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

  Util.wordList = function(_arg) {
    var size, word, words, _i, _len, _ref, _results;
    size = _arg.size, words = _arg.words;
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

  Util.isValidSwapCoordinates = function(_arg) {
    var isMovingDiagonaly, isValid, movingHorizontaly, movingVerticaly, range, x1, x2, y1, y2;
    x1 = _arg.x1, y1 = _arg.y1, x2 = _arg.x2, y2 = _arg.y2, range = _arg.range;
    movingHorizontaly = Math.abs(x2 - x1);
    movingVerticaly = Math.abs(y2 - y1);
    isMovingDiagonaly = (movingHorizontaly > 0) && (movingVerticaly > 0);
    isValid = isMovingDiagonaly ? false : (movingHorizontaly === 1) || (movingVerticaly === 1);
    if (isValid && (range != null)) {
      return this.inRange({
        x: x1,
        y: y1,
        range: range
      }) && this.inRange({
        x: x2,
        y: y2,
        range: range
      });
    } else {
      return isValid;
    }
  };

  Util.createSwapCoordinate = function(_arg, _arg1) {
    var x1, x2, y1, y2;
    x1 = _arg.x, y1 = _arg.y;
    x2 = _arg1.x, y2 = _arg1.y;
    return {
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2
    };
  };

  Util.createSwipeCoordinate = function(_arg, _arg1) {
    var x, xi, y, yi;
    x = _arg.x, y = _arg.y;
    xi = _arg1.x, yi = _arg1.y;
    if (xi != null) {
      x += xi;
    }
    if (yi != null) {
      y += yi;
    }
    return {
      x: x,
      y: y
    };
  };

  Message = Util.Message = (function() {
    var playerInfo;

    function _Class() {}

    playerInfo = function(_arg) {
      var player, score, _ref;
      player = _arg.player, score = _arg.score;
      return {
        name: player != null ? typeof player.name === "function" ? player.name() : void 0 : void 0,
        numberWords: score != null ? (_ref = score.newWords) != null ? _ref.length : void 0 : void 0,
        points: score != null ? score.points : void 0,
        words: (score != null ? score.newWords : void 0) || []
      };
    };

    _Class.points = function(_arg) {
      var message, player, score, w, words, _i, _len, _ref;
      player = _arg.player, score = _arg.score;
      player = playerInfo({
        player: player,
        score: score
      });
      words = '';
      _ref = player.words;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        w = _ref[_i];
        words += "" + w + " ";
      }
      message = "" + player.name + " formed the following " + player.numberWords + " word(s):";
      message += "<br>" + words + "<br>";
      return message += "Earning " + player.points + " points";
    };

    _Class.tile = function(_arg) {
      var player, playerName, tile, x, y, _ref;
      tile = _arg.tile, player = _arg.player;
      playerName = player != null ? player.name() : void 0;
      _ref = (tile != null ? tile.coordinate : void 0) || {}, x = _ref.x, y = _ref.y;
      return "" + playerName + " selected tile (" + x + ", " + y + ")";
    };

    return _Class;

  })();

}).call(this);

(function() {
  var Player;

  Player = this.Scrabble.Player = (function() {
    function _Class(_arg) {
      var moveCount, name, score, words, _ref;
      name = (_arg != null ? _arg : {}).name;
      _ref = [0, 0, []], score = _ref[0], moveCount = _ref[1], words = _ref[2];
      this.name = function() {
        return name;
      };
      this.score = function() {
        return score;
      };
      this.moveCount = function() {
        return moveCount;
      };
      this.words = function() {
        var word, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = words.length; _i < _len; _i++) {
          word = words[_i];
          _results.push(word);
        }
        return _results;
      };
      this.move = function(_arg1) {
        var board, result, swapCoordinates, _ref1;
        _ref1 = _arg1 != null ? _arg1 : {}, board = _ref1.board, swapCoordinates = _ref1.swapCoordinates;
        if (!((board != null) || (swapCoordinates != null))) {
          return;
        }
        result = board.move(swapCoordinates);
        if (result != null) {
          moveCount++;
          score += result.points;
          words.push.apply(words, result.newWords);
          words.sort();
        }
        return result;
      };
    }

    return _Class;

  })();

}).call(this);

(function() {
  var Score, Scrabble, Util, VALUES, WordFinder,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Scrabble = this.Scrabble;

  Util = Scrabble.Util, WordFinder = Scrabble.WordFinder;

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

  Score = Scrabble.Score = (function() {
    function _Class(_arg) {
      var dictionary, grid;
      grid = _arg.grid, dictionary = _arg.dictionary;
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

  Score.words = function(_arg) {
    var SIZE, dictionary, grid, word, words, words_on_xy, x, y, _i, _j, _k, _len, _ref;
    grid = _arg.grid, dictionary = _arg.dictionary;
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

  Score.move = function(_arg) {
    var col1, col2, grid, isValidMove, range, row1, row2, _ref, _ref1;
    grid = _arg.grid, (_ref = _arg.swapCoordinates, col1 = _ref.x1, row1 = _ref.y1, col2 = _ref.x2, row2 = _ref.y2);
    range = Util.sizeMatrix(grid);
    isValidMove = Util.isValidSwapCoordinates({
      x1: col1,
      y1: row1,
      x2: col2,
      y2: row2,
      range: range
    });
    if ((range != null) && isValidMove) {
      _ref1 = [grid[row1][col1], grid[row2][col2]], grid[row2][col2] = _ref1[0], grid[row1][col1] = _ref1[1];
      return true;
    } else {
      return false;
    }
  };

  Score.moveScore = function(_arg) {
    var dictionary, grid, new_words, swapCoordinates, words_after_moving, words_before_moving;
    grid = _arg.grid, dictionary = _arg.dictionary, swapCoordinates = _arg.swapCoordinates;
    words_before_moving = this.words({
      grid: grid,
      dictionary: dictionary
    });
    if (this.move({
      grid: grid,
      swapCoordinates: swapCoordinates
    })) {
      words_after_moving = this.words({
        grid: grid,
        dictionary: dictionary
      });
      new_words = this.newWords({
        before: words_before_moving,
        after: words_after_moving
      });
      return {
        points: this.scoreWords(new_words),
        newWords: new_words
      };
    }
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

  Score.newWords = function(_arg) {
    var new_word, words_after, words_before, _i, _len, _results;
    words_before = _arg.before, words_after = _arg.after;
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
  var Board, Score, Scrabble, Util, WordFinder;

  Scrabble = this.Scrabble;

  Util = Scrabble.Util, Score = Scrabble.Score, WordFinder = Scrabble.WordFinder;

  Board = Scrabble.Board = (function() {
    function _Class(_arg) {
      var grid, size, wordList, words;
      size = _arg.size, words = _arg.words, grid = _arg.grid;
      if (Util.isMatrixQuadratic(grid)) {
        size = Util.sizeMatrix(grid);
      } else {
        grid = void 0;
      }
      if (!Board.isValidSize(size)) {
        throw new Error("Grid size not given");
      }
      grid || (grid = Util.generateGrid(size));
      wordList = Util.wordList({
        size: size,
        words: words
      });
      this.score = new Score({
        grid: grid,
        dictionary: wordList
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
        return this.score.moveScore(swapCoordinates);
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

  Board.isValidSize = function(size) {
    if ((!size) || size < 0) {
      return false;
    } else {
      return true;
    }
  };

}).call(this);

(function() {
  var Board, DEFAULT_VIEW, Game, Player, Scrabble, Util, defaultView;

  Scrabble = this.Scrabble;

  Board = Scrabble.Board, Player = Scrabble.Player, Util = Scrabble.Util, defaultView = Scrabble.defaultView;

  DEFAULT_VIEW = defaultView();

  Game = Scrabble.Game = (function() {
    var watchTilesDefault;

    function _Class(_arg) {
      this.words = (_arg != null ? _arg : {}).words;
      if (this.words == null) {
        throw new Error("Board or words was not given");
      }
    }

    _Class.prototype["new"] = function(_arg) {
      var VIEW, board, player1, player2, size, _ref,
        _this = this;
      _ref = _arg != null ? _arg : {}, size = _ref.size, player1 = _ref.player1, player2 = _ref.player2, board = _ref.board, this.DOM = _ref.DOM, VIEW = _ref.VIEW;
      this.board = board || new Board({
        size: size || 5,
        words: this.words
      });
      this.currentPlayer = this.player1 = player1 || new Player({
        name: 'Player 1'
      });
      this.player2 = player2 || new Player({
        name: 'Player 2'
      });
      this.VIEW = VIEW || DEFAULT_VIEW;
      this.move = function(swapCoordinates) {
        var moveScore;
        _this.lastMove = $.extend({}, {
          swapCoordinates: swapCoordinates
        });
        moveScore = _this.currentPlayer.move({
          board: _this.board,
          swapCoordinates: swapCoordinates
        });
        _this.message({
          score: moveScore
        });
        if (moveScore) {
          $.extend(_this.lastMove, moveScore);
          _this.currentPlayer = _this.currentPlayer === _this.player1 ? _this.player2 : _this.player1;
          _this.view.update();
        }
        return _this.lastMove;
      };
      this.initView();
      return this;
    };

    watchTilesDefault = function(tile) {
      var firstCoord, secondCoord, swapCoordinates;
      if (this.view.selectedTile == null) {
        this.view.selectedTile = $.extend({}, tile);
        this.view.selectedTile.$el.addClass('selected');
        return this.message({
          tile: tile
        });
      } else {
        firstCoord = this.view.selectedTile.coordinate;
        secondCoord = tile.coordinate;
        swapCoordinates = Util.createSwapCoordinate(firstCoord, secondCoord);
        this.move(swapCoordinates);
        this.view.selectedTile.$el.removeClass('selected');
        return this.view.selectedTile = void 0;
      }
    };

    _Class.prototype.initView = function(_arg) {
      var watchTiles,
        _this = this;
      watchTiles = (_arg != null ? _arg : {}).watchTiles;
      this.view = new Game.View({
        ELEMENTS: this.VIEW,
        context: this.DOM,
        game: this
      });
      this.view.updatePlayerNames();
      this.view.update();
      this.view.watchTiles(function(tile) {
        if (watchTiles != null) {
          return watchTiles(tile);
        } else {
          return watchTilesDefault.call(_this, tile);
        }
      });
    };

    _Class.prototype.message = function(_arg) {
      var id, message, player, score, tile;
      score = _arg.score, tile = _arg.tile;
      player = this.currentPlayer;
      id = DEFAULT_VIEW.MESSAGE;
      if (tile != null) {
        message = Util.Message.tile({
          tile: tile,
          player: player
        });
      }
      message || (message = score ? (id = DEFAULT_VIEW.NOTICE, Util.Message.points({
        player: player,
        score: score
      })) : "Invalid move");
      Game.View.showMessage({
        message: message,
        context: this.DOM,
        id: id
      });
    };

    return _Class;

  })();

}).call(this);

(function() {
  var DEFAULT_VIEW, Game, Scrabble, Util, View, defaultView;

  Scrabble = this.Scrabble;

  Util = Scrabble.Util, Game = Scrabble.Game, defaultView = Scrabble.defaultView;

  DEFAULT_VIEW = defaultView();

  View = Game.View = (function() {
    function _Class(_arg) {
      var ELEMENTS, context, _ref, _ref1, _ref10, _ref11, _ref12, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      _ref = _arg != null ? _arg : {}, ELEMENTS = _ref.ELEMENTS, context = _ref.context, this.game = _ref.game;
      this.watcherTiles = [];
      this.$p1name = $("#" + (ELEMENTS != null ? (_ref1 = ELEMENTS.PLAYER) != null ? (_ref2 = _ref1.ONE) != null ? _ref2.NAME : void 0 : void 0 : void 0), context);
      this.$p1score = $("#" + (ELEMENTS != null ? (_ref3 = ELEMENTS.PLAYER) != null ? (_ref4 = _ref3.ONE) != null ? _ref4.SCORE : void 0 : void 0 : void 0), context);
      this.$p1message = $("#" + (ELEMENTS != null ? (_ref5 = ELEMENTS.PLAYER) != null ? (_ref6 = _ref5.ONE) != null ? _ref6.MSG : void 0 : void 0 : void 0), context);
      this.$p2name = $("#" + (ELEMENTS != null ? (_ref7 = ELEMENTS.PLAYER) != null ? (_ref8 = _ref7.TWO) != null ? _ref8.NAME : void 0 : void 0 : void 0), context);
      this.$p2score = $("#" + (ELEMENTS != null ? (_ref9 = ELEMENTS.PLAYER) != null ? (_ref10 = _ref9.TWO) != null ? _ref10.SCORE : void 0 : void 0 : void 0), context);
      this.$p2message = $("#" + (ELEMENTS != null ? (_ref11 = ELEMENTS.PLAYER) != null ? (_ref12 = _ref11.TWO) != null ? _ref12.MSG : void 0 : void 0 : void 0), context);
      this.$grid = $("#" + (ELEMENTS != null ? ELEMENTS.GRID : void 0), context);
    }

    _Class.prototype.updateScore = function() {
      var p1score, p2score, _ref, _ref1, _ref2, _ref3;
      p1score = (_ref = this.game) != null ? (_ref1 = _ref.player1) != null ? _ref1.score() : void 0 : void 0;
      p2score = (_ref2 = this.game) != null ? (_ref3 = _ref2.player2) != null ? _ref3.score() : void 0 : void 0;
      this.$p1score.html(p1score);
      this.$p2score.html(p2score);
    };

    _Class.prototype.updatePlayerNames = function() {
      this.$p1name.html(this.game.player1.name());
      this.$p2name.html(this.game.player2.name());
    };

    _Class.prototype.updatePlayerWords = function() {
      var p1words, p2words, word, _i, _j, _len, _len1, _ref, _ref1;
      p2words = p1words = '';
      _ref = this.game.player1.words();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        word = _ref[_i];
        p1words += "" + word + " ";
      }
      _ref1 = this.game.player2.words();
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        word = _ref1[_j];
        p2words += "" + word + " ";
      }
      this.$p1message.html("" + p1words);
      this.$p2message.html("" + p2words);
    };

    _Class.prototype.updateGrid = function() {
      var watcher, _i, _len, _ref;
      this.$grid.empty().append(View.createGrid(this.game.board.matrix()));
      _ref = this.watcherTiles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        watcher = _ref[_i];
        this.registerWatchTiles(watcher);
      }
    };

    _Class.prototype.update = function() {
      this.updateScore();
      this.updatePlayerWords();
      this.updateGrid();
    };

    _Class.prototype.watchTiles = function(callback) {
      this.watcherTiles.push(callback);
      this.registerWatchTiles(callback);
    };

    _Class.prototype.registerWatchTiles = function(callback) {
      var $grid, tile;
      $grid = this.$grid;
      tile = {};
      $grid.find('li').on({
        "catchTileInfo": function(event) {
          var coordinate, swapCoordinate, swipeCoordinate;
          coordinate = View.getCoordinate({
            grid: $grid,
            tile: this
          });
          swipeCoordinate = Util.createSwipeCoordinate(coordinate, event.data || {});
          swapCoordinate = Util.createSwapCoordinate(coordinate, swipeCoordinate);
          $.extend(tile, {
            coordinate: coordinate,
            el: this,
            $el: $(this)
          });
          if (event.data != null) {
            $.extend(tile, {
              swipeCoordinate: swipeCoordinate,
              swapCoordinate: swapCoordinate
            });
          }
          return callback(tile);
        },
        "click": function() {
          return $(this).trigger('catchTileInfo');
        },
        "swipeRight": function() {
          return $(this).trigger('catchTileInfo', {
            x: 1
          });
        },
        "swipeLeft": function() {
          return $(this).trigger('catchTileInfo', {
            x: -1
          });
        },
        "swipeUp": function() {
          return $(this).trigger('catchTileInfo', {
            y: -1
          });
        },
        "swipeDown": function() {
          return $(this).trigger('catchTileInfo', {
            y: 1
          });
        }
      });
    };

    _Class.prototype.unwatchTiles = function() {
      this.watcherTiles = [];
      this.$grid.find('li').off();
    };

    return _Class;

  })();

  View.showMessage = function(_arg) {
    var $id, context, id, message, _ref;
    _ref = _arg != null ? _arg : {}, message = _ref.message, context = _ref.context, id = _ref.id;
    $id = $("#" + id, context);
    $id.html(message);
  };

  View.createGridLine = function(line) {
    var lineHtml, value, _i, _len;
    lineHtml = '';
    for (_i = 0, _len = line.length; _i < _len; _i++) {
      value = line[_i];
      lineHtml += "<li>" + value + "</li>";
    }
    return $(lineHtml);
  };

  View.createGrid = function(grid) {
    var gridHtml, line, ul, _i, _len;
    gridHtml = $('<div>');
    for (_i = 0, _len = grid.length; _i < _len; _i++) {
      line = grid[_i];
      ul = $('<ul>');
      gridHtml.append(ul.append(this.createGridLine(line)));
    }
    return gridHtml.contents();
  };

  View.getCoordinate = function(_arg) {
    var $li, $lis, $ul, $uls, grid, tile;
    grid = _arg.grid, tile = _arg.tile;
    $li = $(tile);
    $ul = $li.parent();
    $lis = $ul.children();
    $uls = $ul.parent().children();
    return {
      x: $lis.index($li),
      y: $uls.index($ul)
    };
  };

}).call(this);
