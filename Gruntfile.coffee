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
        src: 'src'
        app: 'app'
        test: 'test'
      
    # Watch for files changing
    watch:
      sourceFiles:
        files: ['<%= config.path.src %>/**/*.coffee']
        tasks: [
          'newer:coffeelint'
          'newer:coffee'
        ]
        options:
          livereload: true

      mochaTest:
        files: ['<%= config.path.test %>/**/*.coffee']
        tasks: [
          'newer:coffeelint:tests'
          'mochaTest'
        ]

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
          "<%= config.path.app %>/**/*.{js,json}"
          "!<%= config.path.app %>/public/{js,lib}/**/*.js"
        ]
        tasks: [
          "express:dev"
          "wait"
        ]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

    # check source syntax
    coffeelint:
      sources: ['<%= config.path.src %>/**/*.coffee']
      tests: ['<%= config.path.test %>/**/*.coffee']
      options:
        configFile: 'coffeelint.json'

    # Compile sources
    coffee:
      options:
        bare: true  # not needed for node.js
        sourceMap: false
      sourceFiles:
        src: ['**/*.coffee']
        cwd: '<%= config.path.src %>/'
        dest: '<%= config.path.app %>/'
        ext: '.js'
        expand: true
        flatten: false

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
      debug:
        tasks: [
          'nodemon'
          'node-inspector'
        ]
        options:
          limit: 3
          logConcurrentOutput: true

    # Set environment variables
    env:
      options:
        add:
          HTTP_PORT: 3000
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
      src: ['test/**/*.coffee']
      options:
        reporter: 'spec'
        require: ['coffee-script/register', 'bin/www']

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
    'build'
  ]

  grunt.registerTask 'build', [
    'lint:sources'
    'coffee'
  ]

  grunt.registerTask 'serve', (target) ->
    if target is 'debug'
      grunt.config.set 'coffee.options.sourceMap', true
      grunt.task.run [
        "build"
        "env:dev"
        "concurrent:debug"
      ]

    grunt.task.run [
      "build"
      "env:dev"
      "express:dev"
      "wait"
      "open"
      "watch"
    ]
  
  # Lint task(s).
  grunt.registerTask 'lint', [
    'coffeelint'
  ]
  
  # Test task.
  grunt.registerTask 'test', [
    'env:test'
    'coffeelint:tests'
    'mochaTest'
    'watch:mochaTest'
  ]
  return
