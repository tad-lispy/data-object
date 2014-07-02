_       = require 'lodash'
path    = require 'path'
fs      = require 'fs'
cson    = require 'cson-safe'
Error2  = require 'error2'

class ConfigPrototype
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

    # Merge loaded data with this object
    _(@).merge cfg
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

  get : (key = '/', options = {}) ->
    _.defaults options,
      throw: no   # throw an error key is not present?
    data  = @
    stack = "/"
    for segment in key.split '/'
      if not segment then continue
      stack += "#{segment}/"
      if not data[segment] # Missing segment?
        if options.throw then throw new Error2
          name    : "Not found"
          message : "Config key not found at #{stack}"
          nearest : stack
          segment : segment
          key     : key
        else return data[segment]
      data = data[segment]

    return _.cloneDeep data

  clear: -> delete @[key] for key of @

# Hide functionality to avoid accidental overwriting
class Config extends ConfigPrototype
module.exports = new Config

###

[CSON]: https://github.com/bevry/cson

###
