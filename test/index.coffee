should = require 'should'
path   = require 'path'

config = require '../'

describe 'config-object', ->
  it 'initially is an empty object', ->
    config.should.eql {}

  it 'can load cson from absolute path', ->
    filename = path.resolve __dirname, 'one.cson'
    config.load filename
    config.should.eql
      name  : 'Test case one'
      result:
        good  : yes

  it 'can be cleared', ->
    do config.clear
    config.should.eql {}

  it 'can load cson from relative path', ->
    config.load 'one.cson'
    config.should.eql
      name  : 'Test case one'
      result:
        good  : yes

  it 'can merge cson files', ->
      config.load 'two.cson'
      config.should.eql
        name  : 'Second test case'
        result:
          good  : yes
          merged: 'very well!'

  it 'can merge json files', ->
    config.load '../package.json'
    config.name.should.equal 'config-object'
    config.result.merged.should.equal 'very well!'

  it 'silently ignores nonexisting files', ->
    config.load '../no-such-file.cson'

  it 'throws error if nonexisting file is required', ->
    fn = -> config.load '../no-such-file.cson', required: yes
    do fn.should.throw

  it 'preserves content after errors', ->
    config.repository.should.eql
      type: "git"
      url : "https://github.com/lzrski/config-object.git"

  it 'can give a value at given path', ->
    value = config.get '/bugs/url'
    value.should.equal 'https://github.com/lzrski/config-object/issues'

  it 'can give a value at given path for arrays as well', ->
    value = config.get '/keywords/0'
    value.should.equal 'configuration'

  it 'can be required again and will expose same content', ->
    config-clone = require '../'
    value = config.get '/keywords/0'
    value.should.equal 'configuration'
    
  # TODO:
  # * arrays of files
  # * config.set

  it 'is cool', -> true
