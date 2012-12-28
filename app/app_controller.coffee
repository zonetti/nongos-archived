app = module.parent.exports

# CRUD operations

create = (req, res) ->
  new req.Collection(req.body).save (err, doc) ->
    if err then return res.send 400, err
    res.send doc

read = (req, res) ->
  res.send req.doc

update = (req, res) ->
  require('underscore').extend(req.doc, req.body)
  req.doc.save (err, doc) ->
    if err then return res.send 400, err
    res.send doc

remove = (req, res) ->
  req.doc.remove (err) ->
    if err then return res.send 400, err
    res.send {}

# Basic REST params

app.param 'collection', (req, res, next, collection) ->
  try
    req.Collection = app.db.model collection
    next()
  catch err
    res.send 400, err

app.param 'id', (req, res, next, id) ->
  req.Collection.findById req.params.id, (err, doc) ->
    if !err and doc != null
      req.doc = doc
      next()
    else if !err
      res.send 404, {}
    else
      res.send 400, err

# Routes

app.get '/:collection', (req, res) ->
  query = req.Collection.find()

  if value = req.query.limit
    query.limit value
    delete req.query.limit

  if value = req.query.skip
    query.skip value
    delete req.query.skip

  if req.query.order
    order = {}
    for field of req.query.order
      order[field] = req.query.order[field]
    query.sort order
    delete req.query.order

  for clause of req.query
    query.where clause, req.query[clause]

  query.exec (err, docs) ->
    if err then return res.send 400, err
    res.send docs

app.get '/:collection/:id', read
app.post '/:collection', create
app.put '/:collection/:id', update
app.delete '/:collection/:id', remove