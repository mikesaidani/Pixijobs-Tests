mongoose = require 'mongoose'

exports.clean = (done) ->
  mongoose.connect 'mongodb://localhost/test', -> 
    mongoose.connection.db.dropDatabase ->
      done();
