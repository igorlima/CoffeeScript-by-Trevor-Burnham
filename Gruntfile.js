module.exports = function(grunt) {
  grunt.initConfig({
    jasmine: {
      options: {
        specs:   'spec/js/**/*.js',
        version: '1.3.1'
      },
      all: {
        src: ['assets/script/js/**/*.js']
      },
      main: {
        src: ['dist/main.js']
      },
      minified: {
        src: ['dist/main.min.js']
      },
      gcc: {
        src: ['dist/main-gcc.min.js']
      }
    },

    jshint: {
      all: ['Gruntfile.js']
    },

    clean: {
      spec:   ['spec/js/**/*.js'],
      script: ['assets/script/js/**/*.js'],
      view:   ['assets/view/html/**/*.html']
    },

    coffee: {
      spec: {
        expand: true,
        flatten: true,
        cwd: 'spec/coffee/',
        src: ['**/*.coffee'],
        dest: 'spec/js/',
        ext: '.js'
      },
      source: {
        expand: true,
        flatten: true,
        cwd: 'assets/script/coffee/',
        src: ['**/*.coffee'],
        dest: 'assets/script/js/',
        ext: '.js'
      }
    },

    concat: {
      main: {
        files: {
          'dist/main.js': ['assets/script/js/**/*.js']
        }
      }
    },

    uglify: {
      main: {
        files: {
          'dist/main.min.js': ['dist/main.js']
        }
      }
    },

    gcc: {
      normal: {
        src: ['dist/main.js'],
        dest: 'dist/main-gcc.min.js'
      }
    },

    jade: {
      options: {
        pretty: true
      },
      compile: {
        expand: true,
        flatten: true,
        cwd: 'assets/view/jade/',
        src: ['**/*.jade'],
        dest: 'assets/view/html/',
        ext: '.html'
      },
      main: {
        files: {
          "dist/index.html": ["assets/view/jade/*.jade"]
        }
      },
      dist: {
        options: {
          pretty: false
        },
        files: {
          "dist/index.html": ["assets/view/jade/*.jade"]
        }
      }
    },

    watch: {
      spec_js: {
        files: ['spec/coffee/**/*.coffee', 'assets/script/coffee/**/*.coffee'],
        tasks: ['clean:spec', 'cleam:script', 'coffee', 'jasmine:all']
      },
      view: {
        files: ['assets/view/jade/**/*.jade'],
        tasks: ['clean:view', 'jade:compile', 'jade:main']
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-gcc');
  grunt.loadNpmTasks('grunt-contrib-jade');

  grunt.registerTask('default', ['jshint', 'clean', 'coffee', 'concat', 'uglify', 'gcc', 'jasmine', 'jade:dist']);

};
