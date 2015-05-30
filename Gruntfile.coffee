module.exports = (grunt) ->
  # Load grunt tasks automatically, when needed
  require("jit-grunt") grunt,
    express: "grunt-express-server"

  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt

  # Project Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # paths and other configs
    config:
      path:
        app: 'app'
        test: 'test'

    # Watch for files changing
    watch:
      coffeescript:
        files: [
          '<%= config.path.app %>/**/*.coffee'
          '!<%= config.path.app %>/public/lib/**/*.coffee'
        ]
        tasks: [
          'newer:coffeelint:sources'
        ]
        options:
          livereload: true
      javascript:
        files: [
          'bin/www'
          '<%= config.path.app %>/**/*.js'
          '!<%= config.path.app %>/public/lib/**/*.js'
        ]
        tasks: [
          'newer:jshint:sources'
        ]
        options:
          livereload: true

      livereload:
        files: [
          "<%= config.path.app %>/public/{css,lib}/**/*.css"
          "<%= config.path.app %>/public/{js,lib}/**/*.js"
          "<%= config.path.app %>/public/**/*.html"
          "<%= config.path.app %>/public/img/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
          "<%= config.path.app %>/views/**/*.jade"
        ]
        options:
          livereload: true

      express:
        files: [
          "<%= config.path.app %>/**/*.{coffee,js,json}"
          "!<%= config.path.app %>/public/{coffee,js,lib}/**/*.{coffee,js}"
        ]
        tasks: [
          "express:dev"
          "wait"
        ]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

    # check coffeescript syntax
    coffeelint:
      sources: [
        '<%= config.path.app %>/**/*.coffee'
        '!<%= config.path.app %>/public/lib/**/*.coffee'
      ]
      tests: ['<%= config.path.test %>/**/*.coffee']
      options:
        configFile: 'coffeelint.json'

    # check javascript syntax
    jshint:
      sources: [
        'bin/www'
        '<%= config.path.app %>/**/*.js'
        '!<%= config.path.app %>/public/lib/**/*.js'
      ]
      options:
        jshintrc: '.jshintrc'

    # Run the express server
    express:
      options:
        port: process.env.PORT or 3000
      dev:
        options:
          script: "bin/www"
          debug: true

    open:
      server:
        url: "http://localhost:<%= express.options.port %>"

    # Restart server with nodemon
    nodemon:
      debug:
        script: 'bin/www'
        options:
          nodeArgs: ['--debug-brk']
          env:
            PORT: process.env.PORT or 3000

          callback: (nodemon) ->
            nodemon.on "log", (event) ->
              console.log event.colour

            # opens browser on initial server start
            nodemon.on "config:update", ->
              setTimeout (->
                require("open") "http://localhost:1337/debug?port=5858"
              ), 500

    # Run node inspector for debug
    'node-inspector':
      custom:
        options:
          'web-port': 1337
          'web-host': 'localhost'
          'debug-port': 5858

    # Run some tasks in paralel
    concurrent:
      options:
        logConcurrentOutput: true
      debug:
        tasks: [
          'nodemon'
          'node-inspector'
        ]

    # Set environment variables
    env:
      options:
        add:
          PORT: 3000
          SERV_PORT: 3030
          MONGODB_USER: ''
          MONGODB_PASS: ''
          MONGODB_SERVER: 'localhost'
          MONGODB_PORT: 27017
      dev:
        NODE_ENV: 'development'
        MONGODB_NAME: 'lazypark-dev'
        DEBUG: '*'
      test:
        NODE_ENV: 'test'
        MONGODB_NAME: 'lazypark-test'

    # Tests
    mochaTest:
      test:
        src: ['test/**/*.spec.coffee']
        options:
          reporter: 'spec'
          require: ['coffee-script/register']

  # Making grunt default to force in order not to break the project.
  # grunt.option 'force', true

  # Used for delaying livereload until after server has restarted
  grunt.registerTask "wait", ->
    grunt.log.ok "Waiting for server reload..."
    done = @async()
    setTimeout (->
      grunt.log.writeln "Done waiting!"
      done()
    ), 1500

  # Default task(s).
  grunt.registerTask 'default', [
    'serve'
  ]

  grunt.registerTask 'serve', (target) ->
    if target is 'debug'
      grunt.task.run [
        "env:dev"
        "concurrent:debug"
      ]

    grunt.task.run [
      "lint"
      "env:dev"
      "express:dev"
      "wait"
      "open"
      "watch"
    ]

  # Lint task(s).
  grunt.registerTask 'lint', [
    'coffeelint'
    'jshint'
  ]

  # Test task.
  grunt.registerTask 'test', [
    'env:test'
    'coffeelint:tests'
    'mochaTest'
  ]
  return
