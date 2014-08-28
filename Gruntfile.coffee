module.exports = (grunt) ->
  
  # Unified Watch Object
  watchFiles =
    sourceFiles: [
      'server.coffee'
      '**/*.coffee'
    ]
    serverFiles: [
      'app/**/*.js'
    ]
    mochaTests: ['test/**/*.coffee']
  
  # Project Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      sourceFiles:
        files: watchFiles.sourceFiles
        tasks: ['coffeelint', 'coffee']
        options:
          livereload: true

    coffeelint:
      sources: ['src/**/*.coffee']
      tests: ['test/**/*.coffee']
      options:
        configFile: 'coffeelint.json'

    coffee:
      sourceFiles:
        src: watchFiles.sourceFiles
        cwd: 'src/'
        dest: 'app/'
        ext: '.js'
        expand: true
        flatten: false
      options:
        bare: true  # not needed for node.js

    nodemon:
      dev:
        script: 'app/server.js'
        options:
          nodeArgs: ['--debug']
          ext: 'js'
          watch: watchFiles.serverFiles

    'node-inspector':
      custom:
        options:
          'web-port': 1337
          'web-host': 'localhost'
          'debug-port': 5858
          'save-live-edit': true
          'no-preload': true
          'stack-trace-limit': 50
          hidden: []

    concurrent:
      default: [
        'nodemon'
        'watch'
      ]
      debug: [
        'nodemon'
        'watch'
        'node-inspector'
      ]
      options:
        logConcurrentOutput: true

    env:
      test:
        NODE_ENV: 'test'

    mochaTest:
      src: watchFiles.mochaTests
      options:
        reporter: 'spec'
        require: ['coffee-script/register', 'app/server.js']

  # Load NPM tasks
  require('load-grunt-tasks') grunt

  # Making grunt default to force in order not to break the project.
  grunt.option 'force', true
  
  # Default task(s).
  grunt.registerTask 'default', [
    'lint'
    'concurrent:default'
  ]
  
  # Debug task.
  grunt.registerTask 'debug', [
    'lint'
    'concurrent:debug'
  ]
  
  # Lint task(s).
  grunt.registerTask 'lint', [
    'coffeelint'
  ]
  
  # Test task.
  grunt.registerTask 'test', [
    'env:test'
    'mochaTest'
  ]
  return
