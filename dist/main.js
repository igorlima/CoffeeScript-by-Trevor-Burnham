(function() {
  var Board, Scrabble;

  Scrabble = this.Scrabble || (this.Scrabble = {});

  Board = Scrabble.Board = (function() {
    function _Class(_arg) {
      var grid, score, size, wordList, words;
      size = _arg.size, words = _arg.words, grid = _arg.grid;
      if (Scrabble.Util.isMatrixQuadratic(grid)) {
        size = Scrabble.Util.sizeMatrix(grid);
      } else {
        grid = void 0;
      }
      if (!Board.isValidSize(size)) {
        throw new Error("Grid size not given");
      }
      grid || (grid = Scrabble.Util.generateGrid(size));
      wordList = Scrabble.Util.wordList({
        size: size,
        words: words
      });
      score = new Scrabble.Score({
        grid: grid,
        dictionary: words
      });
      this.size = function() {
        return size;
      };
      this.isWord = function(str) {
        return Scrabble.WordFinder.isWord({
          word: str,
          dictionary: wordList
        });
      };
      this.move = function(swapCoordinates) {
        return score.moveScore(swapCoordinates);
      };
      this.str = function() {
        return Scrabble.Util.printGrid(grid);
      };
      this.matrix = function() {
        return Scrabble.Util.matrix(grid);
      };
      this.set = function(coordinate) {
        var value, x, y;
        x = coordinate.x, y = coordinate.y, value = coordinate.value;
        return Scrabble.Util.setCoordinate({
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
        return Scrabble.Util.getCoordinate({
          coordinates: grid,
          x: x,
          y: y
        });
      };
    }

    _Class.prototype.inRange = function(num) {
      return Scrabble.Util.inRange({
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
  var DEFAULT_VIEW, Game, Scrabble, View;

  Scrabble = this.Scrabble || (this.Scrabble = {});

  DEFAULT_VIEW = {
    PLAYER: {
      ONE: {
        SCORE: 'p1score',
        NAME: 'p1name'
      },
      TWO: {
        SCORE: 'p2score',
        NAME: 'p2name'
      }
    },
    MESSAGE: 'message',
    GRID: 'grid'
  };

  Game = Scrabble.Game = (function() {
    function _Class(_arg) {
      this.words = (_arg != null ? _arg : {}).words;
      if (this.words == null) {
        throw new Error("Board or words was not given");
      }
    }

    _Class.prototype["new"] = function(_arg) {
      var DOM, VIEW, board, player1, player2, size, _ref;
      _ref = _arg != null ? _arg : {}, size = _ref.size, player1 = _ref.player1, player2 = _ref.player2, board = _ref.board, DOM = _ref.DOM, VIEW = _ref.VIEW;
      this.board = board || new Scrabble.Board({
        size: size || 5,
        words: this.words
      });
      this.currentPlayer = this.player1 = player1 || new Scrabble.Player({
        name: 'Player 1'
      });
      this.player2 = player2 || new Scrabble.Player({
        name: 'Player 2'
      });
      VIEW || (VIEW = DEFAULT_VIEW);
      this.view = new View({
        p1score: VIEW.PLAYER.ONE.SCORE,
        p2score: VIEW.PLAYER.TWO.SCORE,
        p1name: VIEW.PLAYER.ONE.NAME,
        p2name: VIEW.PLAYER.TWO.NAME,
        grid: VIEW.GRID,
        context: DOM,
        game: this
      });
      this.view.updateScore();
      this.view.updatePlayerNames();
      this.view.updateGrid();
      return this;
    };

    return _Class;

  })();

  View = Game.View = (function() {
    function _Class(_arg) {
      var context, grid, p1name, p1score, p2name, p2score, _ref;
      _ref = _arg != null ? _arg : {}, p1score = _ref.p1score, p2score = _ref.p2score, p1name = _ref.p1name, p2name = _ref.p2name, context = _ref.context, grid = _ref.grid, this.game = _ref.game;
      this.$p1name = $("#" + p1name, context);
      this.$p1score = $("#" + p1score, context);
      this.$p2name = $("#" + p2name, context);
      this.$p2score = $("#" + p2score, context);
      this.$grid = $("#" + grid, context);
    }

    _Class.prototype.updateScore = function() {
      this.$p1score.html(0);
      return this.$p2score.html(0);
    };

    _Class.prototype.updatePlayerNames = function() {
      this.$p1name.html(this.game.player1.name());
      return this.$p2name.html(this.game.player2.name());
    };

    _Class.prototype.updateGrid = function() {
      return this.$grid.empty().append(View.createGrid(this.game.board.matrix()));
    };

    _Class.prototype.watchTiles = function(callback) {
      var $grid;
      $grid = this.$grid;
      return $grid.find('li').on('click', function() {
        var coordinate;
        coordinate = View.getCoordinate({
          grid: $grid,
          tile: this
        });
        return callback(coordinate);
      });
    };

    return _Class;

  })();

  View.showMessage = function(_arg) {
    var $id, context, id, message, _ref;
    _ref = _arg != null ? _arg : {}, message = _ref.message, context = _ref.context, id = _ref.id;
    $id = $("#" + (id || DEFAULT_VIEW.MESSAGE), context);
    return $id.html(message);
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

  View.createSwapCoordinate = function(_arg, _arg1) {
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

}).call(this);

(function() {
  var Player, Scrabble;

  Scrabble = this.Scrabble || (this.Scrabble = {});

  Player = Scrabble.Player = (function() {
    function _Class(_arg) {
      var moveCount, name, score, _ref;
      name = (_arg != null ? _arg : {}).name;
      _ref = [0, 0], score = _ref[0], moveCount = _ref[1];
      this.name = function() {
        return name;
      };
      this.score = function() {
        return score;
      };
      this.moveCount = function() {
        return moveCount;
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
          score += result.scoreMove;
        }
        return result;
      };
    }

    return _Class;

  })();

}).call(this);

(function() {
  var Score, Scrabble, VALUES,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Scrabble = this.Scrabble || (this.Scrabble = {});

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
        return Scrabble.Util.printGrid(grid);
      };
      this.matrix = function() {
        return Scrabble.Util.matrix(grid);
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
        words_on_xy = Scrabble.WordFinder.all({
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
    range = Scrabble.Util.sizeMatrix(grid);
    isValidMove = Scrabble.Util.isValidSwapCoordinates({
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
        scoreMove: this.scoreWords(new_words),
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
  var MIN_TILE_LENGTH, Scrabble, TileFinder, findMany, findOne,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Scrabble = this.Scrabble || (this.Scrabble = {});

  TileFinder = Scrabble.TileFinder = (function() {
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
  var Scrabble, Tile, alphabet, count, letter, tileCounts, totalTiles;

  Scrabble = this.Scrabble || (this.Scrabble = {});

  Tile = Scrabble.Tile = (function() {
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
  var Scrabble, Util;

  Scrabble = this.Scrabble || (this.Scrabble = {});

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
          _results1.push(Scrabble.Tile.randomLetter());
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
      if ((Scrabble.TileFinder.MIN_TILE_LENGTH <= (_ref = word.length) && _ref <= size)) {
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
    var isMovingDiagonaly, isMovingHorizontaly, isMovingVerticaly, isValid, range, x1, x2, y1, y2;
    x1 = _arg.x1, y1 = _arg.y1, x2 = _arg.x2, y2 = _arg.y2, range = _arg.range;
    isMovingHorizontaly = Math.abs(x2 - x1) === 1;
    isMovingVerticaly = Math.abs(y2 - y1) === 1;
    isMovingDiagonaly = isMovingHorizontaly && isMovingVerticaly;
    isValid = isMovingDiagonaly ? false : isMovingHorizontaly || isMovingVerticaly;
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

}).call(this);

(function() {
  var Scrabble, WordFinder,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Scrabble = this.Scrabble || (this.Scrabble = {});

  WordFinder = Scrabble.WordFinder = (function() {
    function _Class() {}

    return _Class;

  })();

  WordFinder.isWord = function(_arg) {
    var dictionary, word;
    word = _arg.word, dictionary = _arg.dictionary;
    return __indexOf.call(dictionary, word) >= 0;
  };

  WordFinder.all = function(_arg) {
    var all_tiles, dictionary, grid, range, tile, x, y, _i, _len, _results;
    grid = _arg.grid, dictionary = _arg.dictionary, range = _arg.range, x = _arg.x, y = _arg.y;
    all_tiles = Scrabble.TileFinder.all({
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

}).call(this);
