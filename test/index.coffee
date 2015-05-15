{ expect }  = require 'chai'

Data        = require '../'

describe 'data-object', ->
  describe 'class', ->

    it 'is a function', ->
      expect Data
        .to.be.a 'function'

    it 'throws if anything else then object is passed to it', ->
      expect -> new Data "It's a string!"
        .to.throw 'Data object can only wrap objects. Instead string was passed to the constructor.'

  describe 'instance', ->

    it 'can wrap an existing object', ->
      object =
        title   : 'Data Manipulation in JavaScript'
        author  : 'Katiusza'
        pages   : 48
        chapters: [
          'Introduction'
          'Why do I like chocolates'
          'Can cat be a good programmer'
        ]

      data = new Data object

      for own property of object
        expect data[property]
          .to.eql object[property]

      # And vice versa
      for own property of data
        expect object[property]
          .to.eql data[property]

      # This however doesnt work. Does eql assertion compare prototypes?
      # expect new Data object
      #   .to.eql object

    it 'constructed without any arguments wraps a new empty object', ->
      expect new Data
        .to.be.an 'object'
        .and.to.be.empty

    describe 'get method', ->

      data = null

      beforeEach ->
        data = new Data
          title   : 'Data Manipulation in JavaScript'
          author  :
            name    : 'Katiusza'
            species : 'Cat'
            featurs : [
              'small'
              'funny'
            ]
          pages   : 48
          chapters: [
            'Introduction'
            'Why do I like gorgonzola cheese'
            'Can cat be a good programmer'
          ]

      it 'is a function', ->
        expect data.get
          .to.be.a 'function'

      it 'can get a value of a deep property', ->
        expect data.get '/author/name'
          .to.eql 'Katiusza'

      it 'can clone a value of a deep property'

      it 'will return undefined for non existing deep property'

      it 'will throw an error if asked for non existing deep property and asked for that'

      it 'can map multiple deep properties to an object', ->
        mapped = data.get
          title   : 'title'
          species : 'author/species'

        expected =
          title   : 'Data Manipulation in JavaScript'
          species : 'Cat'

        expect mapped
          .to.eql expected

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
