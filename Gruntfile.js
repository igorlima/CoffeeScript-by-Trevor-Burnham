module.exports = function(grunt) {
  grunt.initConfig({
    jasmine: {
      main: {
        src: ['src/js/**/*.js'],
        options: {
          specs:   'spec/js/**/*.js',
          version: '1.3.1'
        }
      }
    },

    jshint: {
      all: ['Gruntfile.js']
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

    watch: {
      main: {
        files: ['spec/coffee/**/*.coffee', 'src/coffee/**/*.coffee'],
        tasks: ['coffee', 'jasmine']
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['jshint', 'coffee', 'jasmine']);

};
