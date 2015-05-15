gulp        = require 'gulp'
mocha       = require 'gulp-mocha'
coffee      = require 'gulp-coffee'
sourcemaps  = require 'gulp-sourcemaps'
through     = require 'through2'
del         = require 'del'

gulp.task 'clean', (done) ->
  del 'build/**/*', done

gulp.task 'coffee', ->
  development = process.env.NODE_ENV is 'development'

  gulp
    .src 'src/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee()
    # Only write source maps if env is development. Otherwise just pass thgrough.
    .pipe if development then sourcemaps.write() else through.obj()
    .pipe gulp.dest 'build/'

gulp.task 'test', ->
  development = process.env.NODE_ENV is 'development'

  gulp
    .src 'test/*.coffee', read: no
    .pipe mocha
      reporter  : 'spec'
      compilers : 'coffee:coffee-script'
    .once 'error', (error) ->
      console.error 'Tests failed', error
      if development
        return @emit 'end'
      else
        process.exit 1

gulp.task 'build', gulp.series [
  'clean'
  'coffee'
  'test'
]


gulp.task 'watch', (done) ->
  gulp.watch [
    'test/**/*'
    'package.json'
  ], gulp.series [
    'test'
  ]

  gulp.watch [
    # TODO: keep sources in src directory w/ subdirs
    # 'src/**/*.coffee'
    'src/**/*.coffee',
  ], gulp.series [
    'build'
  ]

gulp.task 'develop', gulp.series [
  (done) ->
    process.env.NODE_ENV ?= 'development'
    do done
  'build'
  'watch'
]
