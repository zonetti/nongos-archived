['models', 'controllers'].forEach (dir) ->
  require('fs').readdirSync("#{__dirname}/#{dir}").forEach (file) ->
    require "#{__dirname}/#{dir}/#{file}" if file.match 'coffee'