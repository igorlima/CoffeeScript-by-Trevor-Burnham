vendor = [
  'lib/dom/zepto.min.js'
  'lib/dom/zepto-touch.js'
]

all_js_script_files = [
  'assets/script/js/scrabble.js'
  'assets/script/js/tile.js'
  'assets/script/js/tile-finder.js'
  'assets/script/js/word-finder.js'
  'assets/script/js/util.js'
  'assets/script/js/player.js'
  'assets/script/js/score.js'
  'assets/script/js/board.js'
  'assets/script/js/game.js'
  'assets/script/js/game-view.js'
]

exec_phantomjs = (callback) ->
  portscanner = require 'portscanner'
  exec        = require('child_process').exec
  PHANTOMJS_PORT = 8910
  portscanner.checkPortStatus PHANTOMJS_PORT, 'localhost', (error, status) ->
    if status is 'open'
      callback()
    else
      exec "phantomjs --webdriver=#{PHANTOMJS_PORT}"
      setTimeout (-> callback()), 500

module.exports = (grunt) ->

  grunt.registerTask 'phantomjs', 'Start PhantomJS as a webdriver at 127.0.0.1:8910', ->
    done = this.async()
    exec_phantomjs done

  grunt.registerTask 'server', 'Start a custom web server', ->
    require './scripts/web-server.js'
    done = this.async()
    setTimeout (-> done()), 500

  grunt.initConfig
    jasmine:
      options:
        specs:   'spec/jasmine/js/**/*.js'
        version: '1.3.1'
      all:
        options:
          vendor:  vendor
        src: all_js_script_files
      main:
        src: ['dist/main.js']
      minified:
        src: ['dist/main.min.js']
      gcc:
        src: ['dist/main-gcc.min.js']

    clean:
      vows:    ['spec/vows/js/**/*.js']
      jasmine: ['spec/jasmine/js/**/*.js']
      script:  ['assets/script/js/**/*.js']
      view:    ['assets/view/html/**/*.html']

    coffeelint:
      config:  ['Gruntfile.coffee']
      vows:    ['spec/vows/coffee/**/*.coffee']
      jasmine:
        files:
          src: ['spec/jasmine/coffee/**/*.coffee']
        options:
          max_line_length:
            level: 'ignore'
      source:
        files:
          src: ['assets/script/coffee/**/*.coffee']
        options:
          max_line_length:
            level: 'warn'

    coffee:
      vows:
        expand: true
        flatten: true
        cwd: 'spec/vows/coffee/'
        src: ['**/*.coffee']
        dest: 'spec/vows/js/'
        ext: '.js'
      jasmine:
        expand: true
        flatten: true
        cwd: 'spec/jasmine/coffee/'
        src: ['**/*.coffee']
        dest: 'spec/jasmine/js/'
        ext: '.js'
      source:
        expand: true
        flatten: true
        cwd: 'assets/script/coffee/'
        src: ['**/*.coffee']
        dest: 'assets/script/js/'
        ext: '.js'

    concat:
      script_for_dist:
        files:
          'dist/main.js': [
            vendor...
            all_js_script_files...
            'lib/word_5x5.js'
          ]
      script:
        files:
          'dist/main.js': all_js_script_files
      style:
        files:
          'dist/main.css': ['assets/style/css/**/*.css']

    cssmin:
      main:
        files:
          'dist/main.min.css': ['dist/main.css']

    uglify:
      main:
        files:
          'dist/main.min.js': ['dist/main.js']

    gcc:
      normal:
        src: ['dist/main.js']
        dest: 'dist/main-gcc.min.js'

    jade:
      options:
        pretty: true
        data:
          dist: false
      compile:
        expand:  true
        flatten: true
        cwd: 'assets/view/jade/'
        src: ['**/*.jade']
        dest: 'assets/view/html/'
        ext: '.html'
      main:
        files:
          "dist/index.html": ["assets/view/jade/*.jade"]
      dist:
        options:
          pretty: false
          data:
            dist: true
        files:
          "dist/index.html": ["assets/view/jade/*.jade"]

    watch:
      vows:
        files: ['spec/vows/coffee/**/*.coffee']
        tasks: ['clean:vows', 'coffee:vows']
      spec_js:
        files: [
          'spec/jasmine/coffee/**/*.coffee'
          'assets/script/coffee/**/*.coffee'
        ]
        tasks: [
          'clean:jasmine'
          'clean:script'
          'coffee:jasmine'
          'coffee:source'
          'jasmine:all'
          'concat:script'
        ]
      view:
        files: ['assets/view/jade/**/*.jade', 'assets/style/css/**/*.css']
        tasks: [
          'clean:view'
          'concat:style'
          'cssmin'
          'jade:compile'
          'jade:main'
        ]


  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-gcc'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', [
    'clean'
    'coffeelint'
    'coffee'
    'concat:script'
    'concat:style'
    'jasmine:all'
    'jade:main'
  ]

  grunt.registerTask 'dist', [
    'clean'
    'coffeelint'
    'coffee'
    'concat:script_for_dist'
    'concat:style'
    'cssmin'
    'uglify'
    'gcc'
    'jade:dist'
  ]

  grunt.registerTask 'test', [
    'jasmine:main'
    'jasmine:minified'
    'jasmine:gcc'
  ]
