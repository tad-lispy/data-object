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

  it 'can load an array of files', ->
    do config.clear
    config.load [
      'one.cson'
      '../package.json'
      'two.cson'
    ]
    config.name.should.eql 'Second test case'
    config.keywords[0].should.eql 'configuration'
    config.result.good.should.be.ok

  it 'silently ignores nonexisting files', ->
    config.load '../no-such-file.cson'

  it 'throws error if nonexisting file is required', ->
    fn = -> config.load '../no-such-file.cson', required: yes
    do fn.should.throw

  it 'preserves content after errors', ->
    config.repository.should.eql
      type: "git"
      url : "https://github.com/lzrski/config-object.git"

  it 'can give a value at given key', ->
    value = config.get '/bugs/url'
    value.should.equal 'https://github.com/lzrski/config-object/issues'

  it 'will return undefined for non existing key', ->
    value = config.get '/no/such/path'
    (value is undefined).should.be.ok

  it 'will throw an error if asked for non existing key and so instructed', ->
    fn = -> config.get '/no/such/path', throw: true
    do fn.should.throw

  it 'can give a value at given path for arrays as well', ->
    value = config.get '/keywords/0'
    value.should.equal 'configuration'

  it 'can be altered by changing value retrived from it', ->
    value = config.get '/keywords', clone: no
    value.push 'alternation'
    value = config.get '/keywords'
    ('alternation' in value).should.be.ok
    # value.should.equal 'configuration'

  it 'can be required again and will expose same content', ->
    config2 = require '../'
    value = config2.get '/keywords/0'
    value.should.equal 'configuration'

  it 'allows to set arbitrary paths', ->
    config.set '/a/very/deep/path', 'tresure'
    config.a.very.deep.path.should.eql 'tresure'

    config.set '/a/very/shallow/path', 'junk'
    config.a.very.shallow.path.should.eql 'junk'

  it 'allows to clone itself into new, unrelated config object', ->
    config2 = config.clone root: '/result'
    config2.merged.should.eql 'very well!'

    # Change in new shouldn't affect old one
    config2.merged = 'New value'
    config2.merged.should.eql 'New value'
    config.result.merged.should.equal 'very well!'

  it 'allows to clone itself with limited number of keys', ->
    config.load 'three.cson'
    config2 = config.clone keys: [
      'nested/a'
      'nested/b/b2'
    ]
    config2.should.eql
      nested:
        a:
          a1: 10
          a2: 20
        b:
          b2: 200

  it 'allows to load file at a given path', ->
    config.load 'three.cson', at: '/one/two/three'
    value = config.get '/one/two/three/nested/a/a1'
    value.should.equal 10

  it 'is cool', -> true
