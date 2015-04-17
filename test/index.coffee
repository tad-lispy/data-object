{ expect }  = require 'chai'

Data        = require '../'

describe 'data-object', ->
  it 'initially is an empty object'

  it 'can be cleared'

  it 'preserves content after errors'

  it 'can give a value at given key'

  it 'will return undefined for non existing key'

  it 'will throw an error non existing key if asked for'

  it 'can give a value at given path for arrays as well'

  it 'can be altered by changing value retrived from it'

  it 'allows to set arbitrary paths'

  it 'allows to clone itself into new, unrelated data object'
    # config2 = config.clone root: '/result'
    # config2.merged.should.eql 'very well!'
    #
    # # Change in new shouldn't affect old one
    # config2.merged = 'New value'
    # config2.merged.should.eql 'New value'
    # config.result.merged.should.equal 'very well!'

  it 'allows to clone itself with limited number of keys'
    # config.load 'three.cson'
    # config2 = config.clone keys: [
    #   'nested/a'
    #   'nested/b/b2'
    # ]
    # config2.should.eql
    #   nested:
    #     a:
    #       a1: 10
    #       a2: 20
    #     b:
    #       b2: 200

  it 'is cool', -> true
