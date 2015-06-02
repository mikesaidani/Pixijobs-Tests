should = require 'should'
request = require 'supertest'
database = require './utils/database'
url = require('./utils/config').baseURL

Account = require '../app/models/account'

personal_sid = ''
company_sid = ''

company_profile =
  name :
    real: 'Pixiit'
    url: 'pixiit'
  slogan: 'Simplify Everything'
  description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque'
  extra: 'extra field'

complete_company_profile =
  name :
    real: 'nonono'
    url: 'nonono'
  slogan: 'Simplify Life'
  description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque updatorLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque updatorLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque updatorLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque updator'
  contact:
    website: 'www.test.com'
    social:
      facebook: 'PixiitFb'
      twitter: 'PixiitTwitter'
      google: 'PixiitGgl'

personal_profile =
  name :
    first: 'Mike'
    middle: 'M'
    last: 'S'
    url: 'mike-m-s'

describe 'Profile', ->

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
      
      personal_sid = res.headers.sid
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
        key = account.meta.activation.key
        request(url)
        .post('/account/activate')
        .set('sid', personal_sid)
        .send({key: key})
        .expect(200)
        .end (err, res) ->
          res.should.have.header 'sid'
          res.should.have.header 'meta'

          personal_sid = res.headers.sid
          meta = JSON.parse(res.headers.meta)

          meta.should.have.property 'profile'
          meta.profile.complete.should.be.type 'boolean'
          meta.profile.should.have.property 'complete', false
          meta.profile.should.have.property 'type', 'personal'
          meta.should.have.property 'activation'
          meta.activation.status.should.be.type 'boolean'
          meta.activation.should.have.property 'status', true
          done()

  before (done) ->
    request(url)
    .post('/signup')
    .send({email: 'company@localhost.com', password: 'azerty', type: 'company'})
    .expect(201)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'
      
      company_sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false

      Account.findOne {'local.email' : 'company@localhost.com'}, (err, account) ->
        account.meta.activation.should.be.an.instanceOf(Object).and.have.property 'key'
        key = account.meta.activation.key
        request(url)
        .post('/account/activate')
        .set('sid', company_sid)
        .send({key: key})
        .expect(200)
        .end (err, res) ->
          res.should.have.header 'sid'
          res.should.have.header 'meta'

          company_sid = res.headers.sid
          meta = JSON.parse(res.headers.meta)

          meta.should.have.property 'profile'
          meta.profile.complete.should.be.type 'boolean'
          meta.profile.should.have.property 'complete', false
          meta.profile.should.have.property 'type', 'company'
          meta.should.have.property 'activation'
          meta.activation.status.should.be.type 'boolean'
          meta.activation.should.have.property 'status', true
          done()

  it 'should fail to post if anonymous', (done) ->
    request url
    .post '/profile'
    .send company_profile
    .expect(401)
    .end (err, res) ->
      res.should.not.have.header 'sid'
      res.should.not.have.header 'meta'
      done()


  describe 'Company', ->
    it 'should create a profile if it doesnt exist', (done) ->
      request url
      .post '/profile'
      .set 'sid', company_sid
      .send company_profile
      .expect(201)
      .end (err, res) ->
        res.should.have.header 'sid'
        res.should.have.header 'meta'
        
        company_sid = res.headers.sid
        meta = JSON.parse(res.headers.meta)

        meta.should.have.property 'profile'
        meta.profile.complete.should.be.type 'boolean'
        meta.profile.should.have.property 'complete', true
        meta.profile.should.have.property 'type', 'company'
        meta.should.have.property 'activation'
        meta.activation.status.should.be.type 'boolean'
        meta.activation.should.have.property 'status', true
        done()

    it 'should fail to create a profil twice', (done) ->
      request url
      .post '/profile'
      .set 'sid', company_sid
      .send company_profile
      .expect(403)
      .end (err, res) ->
        res.should.not.have.header 'sid'
        res.should.not.have.header 'meta'
        res.body.should.not.exist
        done()

    it 'should fail to grab own profile if anonymous', (done) ->
      request url
      .get '/profile'
      .set 'sid', company_sid
      .expect(401)
      .end (err, res) ->
        res.should.not.have.header 'sid'
        res.should.not.have.header 'meta'
        res.body.should.not.exist
        done()

    it 'should grab own profile', (done) ->
      request url
      .get '/profile'
      .set 'sid', company_sid
      .expect(200)
      .end (err, res) ->
        res.body.should.not.have.property '_id'
        res.body.should.not.have.property '_account'
        res.body.should.not.have.property '__v'
        res.body.name.should.have.property 'real', company_profile.name.real
        res.body.name.should.have.property 'url', company_profile.name.url
        res.body.should.have.property 'slogan', company_profile.slogan
        res.body.should.have.property 'description', company_profile.description
        done()

    it 'should update a profile', (done) ->
      request url
      .put '/profile'
      .set 'sid', company_sid
      .send complete_company_profile
      .expect(200)
      .end (err, res) ->
        res.should.have.status 200
        res.should.not.have.header 'sid'
        res.should.not.have.header 'meta'
        res.body.should.not.exist
        done()

    it 'should grab own profile after update', (done) ->
      request url
      .get '/profile'
      .set 'sid', company_sid
      .expect(200)
      .end (err, res) ->
        res.body.should.not.have.property '_id'
        res.body.should.not.have.property '_account'
        res.body.should.not.have.property '__v'
        res.body.name.should.have.property 'real', company_profile.name.real
        res.body.name.should.have.property 'url', company_profile.name.url
        res.body.should.have.property 'slogan', complete_company_profile.slogan
        res.body.should.have.property 'description', complete_company_profile.description
        res.body.contact.should.have.property 'website', complete_company_profile.contact.website
        res.body.contact.social.should.have.property 'facebook', complete_company_profile.contact.social.facebook
        res.body.contact.social.should.have.property 'twitter', complete_company_profile.contact.social.twitter
        res.body.contact.social.should.have.property 'google', complete_company_profile.contact.social.google
        done()

    it 'should grab the profile by name', (done) ->
      request url
      .get '/company/pixiit'
      .expect(200)
      .end (err, res) ->
        res.body.should.not.have.property '_id'
        res.body.should.not.have.property '_account'
        res.body.should.not.have.property '__v'
        res.body.name.should.have.property 'real', company_profile.name.real
        res.body.name.should.have.property 'url', company_profile.name.url
        res.body.should.have.property 'slogan', complete_company_profile.slogan
        res.body.should.have.property 'description', complete_company_profile.description
        res.body.contact.should.have.property 'website', complete_company_profile.contact.website
        res.body.contact.social.should.have.property 'facebook', complete_company_profile.contact.social.facebook
        res.body.contact.social.should.have.property 'twitter', complete_company_profile.contact.social.twitter
        res.body.contact.social.should.have.property 'google', complete_company_profile.contact.social.google
        done()

  describe 'Personal', ->
    it 'should create a profile if it doesnt exist', (done) ->
      request url
      .post '/profile'
      .set 'sid', personal_sid
      .send personal_profile
      .expect(201)
      .end (err, res) ->
        res.should.have.header 'sid'
        res.should.have.header 'meta'
        
        personal_sid = res.headers.sid
        meta = JSON.parse(res.headers.meta)

        meta.should.have.property 'profile'
        meta.profile.complete.should.be.type 'boolean'
        meta.profile.should.have.property 'complete', true
        meta.profile.should.have.property 'type', 'personal'
        meta.should.have.property 'activation'
        meta.activation.status.should.be.type 'boolean'
        meta.activation.should.have.property 'status', true
        done()

    it 'should fail to create a profil twice', (done) ->
      request url
      .post '/profile'
      .set 'sid', personal_sid
      .send personal_profile
      .expect(403)
      .end (err, res) ->
        res.should.not.have.header 'sid'
        res.should.not.have.header 'meta'
        res.body.should.not.exist
        done()

    it 'should fault to grab own profile if anonymous', (done) ->
      request url
      .get '/profile'
      .set 'sid', personal_sid
      .expect(401)
      .end (err, res) ->
        res.should.not.have.header 'sid'
        res.should.not.have.header 'meta'
        res.body.should.not.exist
        done()

    it 'should grab own profile', (done) ->
      request url
      .get '/profile'
      .set 'sid', personal_sid
      .expect(200)
      .end (err, res) ->
        res.body.should.not.have.property '_id'
        res.body.should.not.have.property '_account'
        res.body.should.not.have.property '__v'
        res.body.name.should.have.property 'first', 'Mike'
        res.body.name.should.have.property 'middle', 'M'
        res.body.name.should.have.property 'last', 'S'
        res.body.name.should.have.property 'url', 'mike-m-s'
        done()

    it 'should grab the profile by name', (done) ->
      request url
      .get '/resumes/kenda-lydia-saidani'
      .expect(200)
      .end (err, res) ->
        res.body.should.not.have.property '_id'
        res.body.should.not.have.property '_account'
        res.body.should.not.have.property '__v'
        res.body.name.should.have.property 'first', 'Mike'
        res.body.name.should.have.property 'middle', 'M'
        res.body.name.should.have.property 'last', 'S'
        res.body.name.should.have.property 'url', 'mike-m-s'
        done()
