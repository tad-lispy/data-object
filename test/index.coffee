{ expect }  = require 'chai'

Data        = require '../'

describe 'data-object', ->
  describe 'class', ->
    it 'is a function'

  describe 'instance', ->

    it 'can wrap an existing object'

    it 'constructed without any arguments wraps a new empty object'


    describe 'get method', ->
      it 'is a function'

      it 'can get a value of a deep property'

      it 'can clone a value of a deep property'

      it 'will return undefined for non existing deep property'

      it 'will throw an error if asked for non existing deep property and asked for that'

      it 'can map multiple deep properties to an object'

      it 'can clone and map multiple deep properties to an object'

      it 'can get a value of a deep property for arrays as well'

      it 'can get entire object'

      it 'can clone entire object'

      it 'can get a value without given deep properties'

    describe 'set method', ->

      it 'can set a value of a deep property'

    describe 'merge method', ->

      it 'can merge wrapped object with another one'

      it 'can merge wrapped object with another one at a given deep property'

    describe 'delete method', ->

      it 'can delete a deep property'

  describe 'overal experience', ->

    it 'is cool', -> true
