should = require 'should'
request = require 'supertest'
database = require './utils/database'
url = require('./utils/config').baseURL

Account = require '../app/models/account'
key = '' 
sid = ''
sid_renewed = ''

describe 'Activation', ->

  before (done) ->
    database.clean ->
      done()

  before (done) ->
    request(url)
    .post('/signup')
    .send({email: 'personal@localhost.com', password: 'azerty', type: 'personal'})
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


      Account.findOne {'local.email' : 'personal@localhost.com'}, (err, account) ->
        account.meta.activation.should.be.an.instanceOf(Object).and.have.property 'key'
        key = account.meta.activation.key if account
        done()
            
  it 'should deny request if not logged in', (done) ->
    request(url)
    .post('/account/activate')
    .send({key: key})
    .expect(401)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should fail to activate with the wrong key', (done) ->
    request(url)
    .post('/account/activate')
    .set('sid', sid)
    .send({key: 123})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()

  it 'should activate account with correct values', (done) ->
    request(url)
    .post('/account/activate')
    .set('sid', sid)
    .send({key: key})
    .expect(200)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'

      sid_renewed = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'personal'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', true
      done()

  it 'should fail to activate if already active', (done) ->
    request(url)
    .post('/account/activate')
    .set('sid', sid_renewed)
    .send({key: key})
    .expect(400)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()
