_       = require 'lodash'
path    = require 'path'
fs      = require 'fs'
cson    = require 'cson-parser'
Error2  = require 'error2'

module.exports = class Data
  constructor: (object) ->
    _.merge @, object

  # TODO: Implement method wrapper
  get: (path = '/', options = {}) ->
    _.defaults options,
      throw     : yes
      clone     : yes
      separator : '/'

    # if typeof null is 'object' then javascript = 'funny'
    if path is null then path = undefined

    data      = @

    if typeof path is 'object'
      # Run recursively until path is a string
      # TODO: get.call @, value, options
      return _.mapValues path, (value) -> @get value, options

    if typeof path not in ['string', 'undefined']
      throw new TypeError "Argument 'path' has to be a string or a hash"

    stack     = '/'
    segments  = path.split options.separator
    for segment in segments
      if not segment then continue # handle empty segments, e.g. in 'a//b'
      if not data[segment]?
        if options.throw then throw new Error2 {
          name    : 'PropertyError'
          message : "Property #{segment} not found at #{stack}"
          path
          at      : stack # Can't name this property 'stack', as it is used internally
          segment
        }
        else return data[segment] # null or undefined

      data = data[segment]
      stack += segment + '/'

    if options.clone
      return _.clone data, yes
    else
      return data


  load: (filename, options = {}) ->
    _.defaults options,
      required: no        # Should we rise en error if file doesn't exist?
      format  : undefined # Force format of file (json, cson, etc.). Default - guess from extension
      root    : path.dirname (module.parent?.filename or module.filename)

    # In the end every file has to be a string, but ...
    if typeof filename isnt 'string'
      # ... allow arrays to be passed
      if filename.length
        @load f, options for f in filename
        return @
      else
        throw new Error2 "You need to provide a string indicating name of config file"

    filename = path.resolve options.root, filename
    # If required option is enabled then honour it
    if not fs.existsSync filename
      if options.required then throw new Error2
        message : "File not found"
        filename: filename
      else return @

    # Resolve format
    {format} = options
    format  ?= filename.match /[a-z0-9]+$/
    format   = format[0].toLowerCase()

    cfg = switch format
      when 'json' then require filename
      when 'cson' then cson.parse fs.readFileSync filename
      else throw new Error2
        message : 'Config file format not supported'
        filename: filename
        format  : format

    # Where to load new configuration
    point = @
    if options.at
      @set options.at, {} unless @get options.at # Make sure the point exists
      point = @get options.at, clone: no

    # Merge loaded data with this object
    _(point)
      .merge cfg
      .commit()
    return @

  clone: (options = {}) ->
    _.defaults options,
      keys: undefined  # All keys. Pass an array of paths to limit
      root: '/'

    {
      root
      keys
    } = options

    keys ?= (attribute for attribute of @get root) # all attributes of data object
    cfg   = new @constructor
    for key in keys
      cfg.set key, @get root + '/' + key

    return cfg

  set : (key, value) ->
    # key can be a path, like /this/is/a/nested/value
    # in this case it should be recursively created (a'la mkdir -p)
    value = _.cloneDeep value
    segments = key.split('/').filter (segment) -> Boolean segment # Omit empty segments, like //
    if not segments.length then throw new Error2
      message: "Cannot set root of the config-object."
      key    : key

    data  = @
    for segment, i in segments
      if i+1 is segments.length
        data[segment] = value
        return @
      if typeof data[segment] isnt 'object' then data[segment] = {}
      data = data[segment]

  clear: -> delete @[key] for key of @
