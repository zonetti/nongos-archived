express = require 'express'
mongoose = require 'mongoose'
config = require '../config.json'

app = module.exports = express()

mongoString = 'user:pass@host:port/db'
for key in ['user', 'pass', 'host', 'port', 'db']
then mongoString = mongoString.replace key, config[key]
app.db = mongoose.connect mongoString, (err) -> throw err if err

app.configure ->
  app.use express.favicon()
  app.use express.bodyParser()

app.configure 'development', ->
  app.use express.logger 'dev'
  app.use express.errorHandler()

require './load'
require './app_controller'

port = process.env.PORT or 3005
environment = app.get 'env'

app.listen port, ->
  console.log "nongos listening to port #{port} [#{environment}]"