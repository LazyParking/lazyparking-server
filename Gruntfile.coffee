module.exports = (grunt) ->
  # Project Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # Watch for files changing
    watch:
      sourceFiles:
        files: ['app.coffee/**/*.coffee']
        tasks: ['coffeelint', 'coffee']
        options:
          livereload: true

    # check source syntax
    coffeelint:
      sources: ['app.coffee/**/*.coffee']
      tests: ['test/**/*.coffee']
      options:
        configFile: 'coffeelint.json'

    # Compile sources
    coffee:
      options:
        bare: true  # not needed for node.js
        sourceMap: grunt.option('sourceMaps')
      sourceFiles:
        src: ['**/*.coffee']
        cwd: 'app.coffee/'
        dest: 'app/'
        ext: '.js'
        expand: true
        flatten: false

    # Restart server with nodemon
    nodemon:
      dev:
        script: 'bin/www'
        options:
          nodeArgs: ['--debug']
          ext: 'js'
          watch: ['app/**/*.js']

    # Run node inspector for debug
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
      serve: [
        'nodemon'
        'watch'
      ]
      debug: [
        'nodemon'
        'watch'
        'node-inspector'
      ]
      options:
        limit: 3
        logConcurrentOutput: true

    env:
      options:
        add:
          HTTP_PORT: 3000
          SERV_PORT: 3030
      dev:
        NODE_ENV: 'dev'
      test:
        NODE_ENV: 'test'

    mochaTest:
      src: ['test/**/*.coffee']
      options:
        reporter: 'spec'
        require: ['coffee-script/register']

  # Load NPM tasks
  require('load-grunt-tasks') grunt

  # Making grunt default to force in order not to break the project.
  # grunt.option 'force', true
  
  # Default task(s).
  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'build', [
    'lint'
    'coffee'
  ]

  grunt.registerTask 'serve', [
    'build'
    'env:dev'
    'concurrent:serve'
  ]
  
  # Debug task.
  grunt.registerTask 'debug', ->
    if not grunt.option 'sourceMaps'
      grunt.log.subhead 'You may want to use --sourceMaps option'

    grunt.task.run [
      'build'
      'env:dev'
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
