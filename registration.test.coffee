should = require 'should'
request = require 'supertest'
database = require './utils/database'
url = require('./utils/config').baseURL

sid = ''

describe 'Registration', ->

  before (done) ->
    database.clean done

  it 'should register a new company account', (done) ->
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

  it 'should register a new personal account', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'personal@localhost.com', password: 'azerty', type:'personal'})
    .expect(201)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'

      sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'personal'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false
      done()

  it 'should fail to register with a wrong account type', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'another@localhost.com', password: 'amnara', type:'wrong'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register without an account type', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'another@localhost.com', password: 'amnara'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register with an existing email', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'cOmpany@localhost.com', password: 'amnara', type:'company'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register without an email', (done) ->
    request(url)
    .post('/signup')
    .send({password: 'amnara', type:'company'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register with wrong email', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'heefe', password: 'amnara', type:'company'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register with a password with less than 6chars', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'test@test.com', password: '12345', type:'company'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register without a password', (done) ->
    request(url)
    .post('/signup')
    .send({email: 'another@localhost.com', type:'company'})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to register if already logged-in', (done) ->
    request(url)
    .post('/signup')
    .set('sid', sid)
    .send({email: 'another@localhost.com', password: 'foobar', type:'company'})
    .expect(403)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()
