# nongos

nongos is a minimalist [RESTful][1] [JSON][2]-based server written in [CoffeeScript][3].

It combines the power of [NodeJS][4], [MongoDB][8], [Express][5] and [Mongoose][6] to build a basic backend API.

## Quick start

Download or clone the Github repository with:

    $> git clone git://github.com/zonetti/nongos.git
    $> cd nongos
    $> [sudo] npm install
    $> node app

## Usage

All you need to do is to design your database schema.

Once you have defined your models and started the nongos server, you will be able to use its [RESTful][1] features through the appropriate routes. (See [Routing][9])

### Models

Example:

```coffeescript
# models/User.coffee

mongoose = require 'mongoose'

UserSchema = new mongoose.Schema
  name: String
  age: Number
  updated_at: Date
  created_at: Date

UserSchema.pre 'save', (next) ->
  field = if this.isNew then 'created_at' else 'updated_at'
  this[field] = new Date()
  next()

mongoose.model 'users', UserSchema
```

You can find more information on modeling in [Mongoose][10] docs.

### Routing

nongos implements the [RESTful][1] pattern for routing, allowing you to **find**, **read**, **create**, **update** and **remove** objects based on your database schema easily.

Following the example above, your routes would be:

#### Find

    GET /users
    GET /users?limit=10&skip=5
    GET /users?limit=5&order[name]=asc&order[email]=desc
    GET /users?order[name]=desc&age=20

#### Read

    GET /users/:id

#### Create

    POST /users

    // sending postfields in JSON format
    // example

    {
      "name": "John Doe",
      "email": "john@doe.com",
      "age": 20
    }

#### Update

    PUT /users/:id

    // sending postfields in JSON format

#### Remove

    DELETE /users/:id

### Controllers

In addition to the [RESTful][1] features, nongos allows you to create your own routes or even overwrite existing ones.

Example:

```coffeescript
# controllers/UsersController.coffee

app = module.parent.exports

User = app.db.model 'users'

app.get '/users', (req, res) ->
  User.find {}, (err, users) ->
    if err return res.send 400, err
    res.send result: users
```

[1]: http://en.wikipedia.org/wiki/Representational_State_Transfer
[2]: http://www.json.org/
[3]: http://coffeescript.org/
[4]: http://nodejs.org/
[5]: http://expressjs.com/
[6]: http://mongoosejs.com/
[7]: http://coffeescript.org/#installation
[8]: http://www.mongodb.org/
[9]: https://github.com/zonetti/nongos#routing
[10]: http://mongoosejs.com/docs/guide.html