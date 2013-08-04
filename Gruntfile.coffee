module.exports = (grunt) ->
  grunt.initConfig
    jasmine:
      options:
        specs:   'spec/jasmine/js/**/*.js'
        vendor:  ['lib/dom/zepto.min.js']
        version: '1.3.1'
      all:
        src: ['assets/script/js/**/*.js']
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
      jasmine: ['spec/jasmine/coffee/**/*.coffee']
      source:  ['assets/script/coffee/**/*.coffee']

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
      script:
        files:
          'dist/main.js': ['assets/script/js/**/*.js']
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
      compile:
        expand: true
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
    'concat'
    'cssmin'
    'uglify'
    'gcc'
    'jasmine'
    'jade:dist'
  ]
