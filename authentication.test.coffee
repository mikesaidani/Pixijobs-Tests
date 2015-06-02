should = require 'should'
request = require 'supertest'
database = require './utils/database'
url = require('./utils/config').baseURL

sid = '' 

describe 'Authentication', ->

  before (done) ->
    database.clean ->
      done()

  before (done) ->
    request(url)
    .post('/signup')
    .send({email: 'company@localhost.com', password: 'azerty', type: 'company'})
    .expect(201)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'
      
      sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false
      done()

  it 'should fail to login without an email', (done) ->
    request(url)
    .post('/login')
    .send({password: 'wrongpassword'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to login without a password', (done) ->
    request(url)
    .post('/login')
    .send({email: 'company@localhost.com'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to login with incorrect credentials', (done) ->
    request(url)
    .post('/login')
    .send({email: 'company@localhost.com', password: 'wrongpassword'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should login with correct credentials', (done) ->
    request(url)
    .post('/login')
    .send({email: 'company@localhost.com', password: 'azerty'})
    .expect(200)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'
      
      sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false
      done()

  it 'should fail to login if already authenticated', (done) ->
    request(url)
    .post('/login')
    .send({email: 'company@localhost.com', password: 'azerty'})
    .set('sid', sid)
    .expect(403)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should accept relogin request', (done) ->
    request(url)
    .post('/relogin')
    .set('sid', sid)
    .end (err, res) ->
      res.should.have.status 200
      res.should.not.have.header 'sid'
      res.should.have.header 'meta'
      
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false
      done()

  it 'should deny relogin request if anonymous', (done) ->
    request(url)
    .post('/relogin')
    .expect(401)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should logout', (done) ->
    request(url)
    .post('/logout')
    .set('sid', sid)
    .expect(200)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should deny relogin request after logout', (done) ->
    request(url)
    .post('/relogin')
    .set('sid', sid)
    .expect(401)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()
