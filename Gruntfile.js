module.exports = function(grunt) {
  grunt.initConfig({
    jasmine: {
      all: {
        src: ['src/js/**/*.js'],
        options: {
          specs:   'spec/js/**/*.js',
          version: '1.3.1'
        }
      },
      main: {
        src: ['dist/main.js'],
        options: {
          specs:   'spec/js/**/*.js',
          version: '1.3.1'
        }
      },
      minified: {
        src: ['dist/main.min.js'],
        options: {
          specs:   'spec/js/**/*.js',
          version: '1.3.1'
        }
      },
      gcc: {
        src: ['dist/main-gcc.min.js'],
        options: {
          specs:   'spec/js/**/*.js',
          version: '1.3.1'
        }
      }
    },

    jshint: {
      all: ['Gruntfile.js']
    },

    clean: {
      spec:   ['spec/js/**/*.js'],
      source: ['src/js/**/*.js']
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
        cwd: 'src/coffee/',
        src: ['**/*.coffee'],
        dest: 'src/js/',
        ext: '.js'
      }
    },

    concat: {
      main: {
        files: {
          'dist/main.js': ['src/js/**/*.js']
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
      dist: {
        src: ['dist/main.js'],
        dest: 'dist/main-gcc.min.js'
      }
    },

    watch: {
      main: {
        files: ['spec/coffee/**/*.coffee', 'src/coffee/**/*.coffee'],
        tasks: ['clean', 'coffee', 'jasmine:all']
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

  grunt.registerTask('default', ['jshint', 'clean', 'coffee', 'concat', 'uglify', 'gcc', 'jasmine']);

};
