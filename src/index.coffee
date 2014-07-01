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
    if not path.existsSync filename
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

  set : (key, value) ->
    # TODO: implement
    # key can be a path, like /this/is/a/nested/value
    # in this case it should be recursively created (a'la mkdir -p)
  get : (key = '/') ->
    data  = @
    stack = "/"
    for segment in key.split '/'
      if not segment then continue
      stack += "#{segment}/"
      if not data[segment] then return data[segment]
      data = data[segment]

    return data

  clear: -> delete @[key] for key of @

# Hide functionality to avoid accidental overwriting
class Config extends ConfigPrototype
module.exports = new Config

###

[CSON]: https://github.com/bevry/cson

###
