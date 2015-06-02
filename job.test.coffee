should = require 'should'
request = require 'supertest'
database = require './utils/database'
url = require('./utils/config').baseURL

Account = require '../app/models/account'
Company = require '../app/models/company'
Member  = require '../app/models/member'

personal_sid = ''
company_sid = ''
pixiit_sid = ''
dropbox_sid = ''
pixiit_id = ''
dropbox_id = ''
jobs = []
dropbox_profile =
  name :
    real: 'Dropbox'
    url: 'dropbox'
  slogan: 'Simplify Life'
  description: 'Lorem Ipsum lador'

pixiit_profile =
  name :
    real: 'Pixiit'
    url: 'pixiit'
  slogan: 'Simplify Everything'
  description: 'Lorem Ipsum lador inom'

pixiit_job =
  name : 'Web Designer'
  type: 'fulltime'
  overview: 'Lorem ipsum'
  location:
    city: 'The South District'
    country: 'Iceland'
  salary:
    amount: 5000
    currency: 'USD'
  qualifications: [
    '1st Qualification'
    '2nd Qualification'
  ]
  responsibilities: [
    '1st responsibility'
    '2nd responsibility'
  ]
  benefits: [
    '1st benefit'
    '2nd benefit'
  ]

pixiit_job_url = ''
dropbox_job_url = ''

describe 'Jobs', ->

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
      
      personal_sid = res.headers.sid
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
        .set('sid', personal_sid)
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

  before (done) ->
    request(url)
    .post('/signup')
    .send({email: 'pixiit@localhost.com', password: 'azerty', type: 'company'})
    .expect(201)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'
      
      pixiit_sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false

      Account.findOne {'local.email' : 'pixiit@localhost.com'}, (err, account) ->
        account.meta.activation.should.be.an.instanceOf(Object).and.have.property 'key'
        key = account.meta.activation.key
        request(url)
        .post('/account/activate')
        .set('sid', pixiit_sid)
        .send({key: key})
        .expect(200)
        .end (err, res) ->
          res.should.have.header 'sid'
          res.should.have.header 'meta'

          pixiit_sid = res.headers.sid
          meta = JSON.parse(res.headers.meta)

          meta.should.have.property 'profile'
          meta.profile.complete.should.be.type 'boolean'
          meta.profile.should.have.property 'complete', false
          meta.profile.should.have.property 'type', 'company'
          meta.should.have.property 'activation'
          meta.activation.status.should.be.type 'boolean'
          meta.activation.should.have.property 'status', true
          request url
          .post '/profile/setup'
          .set 'sid', pixiit_sid
          .send pixiit_profile
          .expect(201)
          .end (err, res) ->
            res.should.have.header 'sid'
            res.should.have.header 'meta'
            
            pixiit_sid = res.headers.sid
            meta = JSON.parse(res.headers.meta)

            meta.should.have.property 'profile'
            meta.profile.complete.should.be.type 'boolean'
            meta.profile.should.have.property 'complete', true
            meta.profile.should.have.property 'type', 'company'
            meta.should.have.property 'activation'
            meta.activation.status.should.be.type 'boolean'
            meta.activation.should.have.property 'status', true

            res.body.should.not.have.property '_id'
            res.body.should.not.have.property '_account'
            res.body.should.not.have.property '__v'
            res.body.name.should.have.property 'real', 'Pixiit'
            res.body.name.should.have.property 'url', 'pixiit'
            res.body.should.have.property 'slogan', 'Simplify Everything'
            res.body.should.have.property 'description', 'Lorem Ipsum lador inom'
            done()

  before (done) ->
    request(url)
    .post('/signup')
    .send({email: 'dropbox@localhost.com', password: 'azerty', type: 'company'})
    .expect(201)
    .end (err, res) ->
      res.should.have.header 'sid'
      res.should.have.header 'meta'
      
      dropbox_sid = res.headers.sid
      meta = JSON.parse(res.headers.meta)

      meta.should.have.property 'profile'
      meta.profile.complete.should.be.type 'boolean'
      meta.profile.should.have.property 'complete', false
      meta.profile.should.have.property 'type', 'company'
      meta.should.have.property 'activation'
      meta.activation.status.should.be.type 'boolean'
      meta.activation.should.have.property 'status', false

      Account.findOne {'local.email' : 'dropbox@localhost.com'}, (err, account) ->
        account.meta.activation.should.be.an.instanceOf(Object).and.have.property 'key'
        key = account.meta.activation.key
        request(url)
        .post('/account/activate')
        .set('sid', dropbox_sid)
        .send({key: key})
        .expect(200)
        .end (err, res) ->
          res.should.have.header 'sid'
          res.should.have.header 'meta'

          dropbox_sid = res.headers.sid
          meta = JSON.parse(res.headers.meta)

          meta.should.have.property 'profile'
          meta.profile.complete.should.be.type 'boolean'
          meta.profile.should.have.property 'complete', false
          meta.profile.should.have.property 'type', 'company'
          meta.should.have.property 'activation'
          meta.activation.status.should.be.type 'boolean'
          meta.activation.should.have.property 'status', true
          request url
          .post '/profile/setup'
          .set 'sid', dropbox_sid
          .send dropbox_profile
          .expect(201)
          .end (err, res) ->
            res.should.have.header 'sid'
            res.should.have.header 'meta'
            
            dropbox_sid = res.headers.sid
            meta = JSON.parse(res.headers.meta)

            meta.should.have.property 'profile'
            meta.profile.complete.should.be.type 'boolean'
            meta.profile.should.have.property 'complete', true
            meta.profile.should.have.property 'type', 'company'
            meta.should.have.property 'activation'
            meta.activation.status.should.be.type 'boolean'
            meta.activation.should.have.property 'status', true

            res.body.should.not.have.property '_id'
            res.body.should.not.have.property '_account'
            res.body.should.not.have.property '__v'
            res.body.name.should.have.property 'real', 'Dropbox'
            res.body.name.should.have.property 'url', 'dropbox'
            res.body.should.have.property 'slogan', 'Simplify Life'
            res.body.should.have.property 'description', 'Lorem Ipsum lador'
            done()

  it 'should fail to post a job if anonymous', (done) ->
    request url
    .post '/jobs'
    .expect(401)
    .end (err, res) ->
      res.body.should.not.exist
      done()

  it 'should fail to post a job if not company account', (done) ->
    request url
    .post '/jobs'
    .set 'sid', personal_sid
    .expect(403)
    .end (err, res) ->
      res.body.should.not.exist
      done()

  it 'should fail to post a job if profile not complete', (done) ->
    request url
    .post '/jobs'
    .set 'sid', company_sid
    .expect(403)
    .end (err, res) ->
      res.body.should.not.exist
      done()

  it 'should post a job if a company (pixiit)', (done) ->
    request url
    .post '/jobs'
    .set 'sid', pixiit_sid
    .send pixiit_job
    .expect 201
    .end (err, res) ->
      res.body.should.not.have.property 'id'
      res.body.should.not.have.property '_id'
      res.body.should.not.have.property '__v'
      res.body.should.not.have.property '_shortid'
      res.body.should.have.property 'name', 'Web Designer'
      res.body.should.have.property 'type', 'fulltime'
      res.body.should.have.property 'overview', 'Lorem ipsum'
      res.body.should.have.property 'isown', true
      res.body.should.have.property 'url'

      pixiit_job_url = res.body.url

      res.body.location.should.have.property 'city', 'The South District'
      res.body.location.should.have.property 'country', 'Iceland'

      res.body.salary.should.have.property 'amount', 5000
      res.body.salary.should.have.property 'currency', 'USD'

      res.body.qualifications.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.qualifications.should.eql(['1st Qualification', '2nd Qualification'])

      res.body.responsibilities.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.responsibilities.should.eql(['1st responsibility', '2nd responsibility'])

      res.body.benefits.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.benefits.should.eql(['1st benefit', '2nd benefit'])

      res.body.applications.should.be.instanceof(Array).and.have.lengthOf(0)
      done()

  it 'should post a second job if a company (dropbox)', (done) ->
    request url
    .post '/jobs'
    .set 'sid', dropbox_sid
    .send pixiit_job
    .expect 201
    .end (err, res) ->
      res.body.should.not.have.property 'id'
      res.body.should.not.have.property '_id'
      res.body.should.not.have.property '__v'
      res.body.should.not.have.property '_shortid'
      res.body.should.have.property 'name', 'Web Designer'
      res.body.should.have.property 'type', 'fulltime'
      res.body.should.have.property 'overview', 'Lorem ipsum'
      res.body.should.have.property 'isown', true
      res.body.should.have.property 'url'

      dropbox_job_url = res.body.url

      res.body.location.should.have.property 'city', 'The South District'
      res.body.location.should.have.property 'country', 'Iceland'

      res.body.salary.should.have.property 'amount', 5000
      res.body.salary.should.have.property 'currency', 'USD'

      res.body.qualifications.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.qualifications.should.eql(['1st Qualification', '2nd Qualification'])

      res.body.responsibilities.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.responsibilities.should.eql(['1st responsibility', '2nd responsibility'])

      res.body.benefits.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.benefits.should.eql(['1st benefit', '2nd benefit'])

      res.body.applications.should.be.instanceof(Array).and.have.lengthOf(0)
      done()

  it 'should list all jobs', (done) ->
    request url
    .get '/jobs'
    .expect 200
    .end (err, res) ->
      jobs = res.body
      for job in jobs
        job.should.not.have.property 'id'
        job.should.not.have.property '_id'
        job.should.not.have.property '__v'
        job.should.not.have.property '_shortid'
        job.should.not.have.property 'overview'
        job.should.not.have.property 'isown'

        job.should.have.property 'name', 'Web Designer'
        job.should.have.property 'type', 'fulltime'
        job.should.have.property 'url'

        job.should.have.property 'company'
        job.company.should.be.instanceof(Object)
        job.company.should.have.property 'name'
        job.company.should.have.property 'slogan'

        job.location.should.have.property 'city', 'The South District'
        job.location.should.have.property 'country', 'Iceland'

        job.should.not.have.property 'salary'
        job.should.not.have.property 'qualifications'
        job.should.not.have.property 'responsibilities'
        job.should.not.have.property 'benefits'
        job.should.not.have.property 'applications'
      done()

  it 'should fail to update a job if anonymous', (done) ->
    request url
    .put '/jobs/' + pixiit_job_url
    .send {location: 'NA'}
    .end (err, res) ->
      res.should.have.status 401
      done()

  it 'should fail to update a job if not owner', (done) ->
    request url
    .put '/jobs/' + pixiit_job_url
    .set 'sid', dropbox_sid
    .send {location: 'NA'}
    .end (err, res) ->
      res.should.have.status 403
      done()

  it 'should update a job', (done) ->
    job =
      name : 'Web Designer Pixiit'
      type: 'parttime'
      overview: 'Lorem ipsum dalor'
      location:
        city: 'The North District'
        country: 'Ireland'
      salary:
        amount: 4000
        currency: 'EUR'
      qualifications: [
        '3st Qualification'
        '4nd Qualification'
      ]
      responsibilities: [
        '3st responsibility'
        '4nd responsibility'
      ]
      benefits: [
        '3st benefit'
        '4nd benefit'
      ]
    request url
    .put '/jobs/' + pixiit_job_url
    .set 'sid', pixiit_sid
    .send job
    .end (err, res) ->
      res.should.have.status 201
      res.body.should.not.have.property 'id'
      res.body.should.not.have.property '_id'
      res.body.should.not.have.property '__v'
      res.body.should.not.have.property '_shortid'
      res.body.should.have.property 'name', 'Web Designer Pixiit'
      res.body.should.have.property 'type', 'parttime'
      res.body.should.have.property 'overview', 'Lorem ipsum dalor'
      res.body.should.have.property 'isown', true
      res.body.should.have.property 'url'

      pixiit_job_url = res.body.url

      res.body.location.should.have.property 'city', 'The North District'
      res.body.location.should.have.property 'country', 'Ireland'

      res.body.salary.should.have.property 'amount', 4000
      res.body.salary.should.have.property 'currency', 'EUR'

      res.body.qualifications.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.qualifications.should.eql(['3st Qualification', '4nd Qualification'])

      res.body.responsibilities.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.responsibilities.should.eql(['3st responsibility', '4nd responsibility'])

      res.body.benefits.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.benefits.should.eql(['3st benefit', '4nd benefit'])

      res.body.applications.should.be.instanceof(Array).and.have.lengthOf(0)
      done()

  it 'should view a single job', (done) ->
    request url
    .get '/jobs/' + pixiit_job_url
    .end (err, res) ->
      res.should.have.status 200
      res.body.should.not.have.property 'id'
      res.body.should.not.have.property '_id'
      res.body.should.not.have.property '__v'
      res.body.should.not.have.property '_shortid'
      res.body.should.have.property 'name', 'Web Designer Pixiit'
      res.body.should.have.property 'type', 'parttime'
      res.body.should.have.property 'overview', 'Lorem ipsum dalor'
      res.body.should.have.property 'isown', false
      res.body.should.have.property 'url'

      res.body.should.have.property 'company'
      res.body.company.should.be.instanceof(Object)
      res.body.company.should.have.property 'name'
      res.body.company.should.have.property 'slogan'
      res.body.company.should.have.property 'description'

      res.body.location.should.have.property 'city', 'The North District'
      res.body.location.should.have.property 'country', 'Ireland'

      res.body.salary.should.have.property 'amount', 4000
      res.body.salary.should.have.property 'currency', 'EUR'

      res.body.qualifications.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.qualifications.should.eql(['3st Qualification', '4nd Qualification'])
      res.body.responsibilities.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.responsibilities.should.eql(['3st responsibility', '4nd responsibility'])

      res.body.benefits.should.be.instanceof(Array).and.have.lengthOf(2)
      res.body.benefits.should.eql(['3st benefit', '4nd benefit'])

      done()

  ##it 'should fail to apply if not authenticated', (done) ->
    ##request url
    ##.post '/jobs/' + jobs[0]._id + '/apply'
    ##.end (err, res) ->
      ##res.should.have.status 401
      ##done()

  ##it 'should fail to apply if not member', (done) ->
    ##request url
    ##.post '/jobs/' + jobs[0]._id + '/apply'
    ##.set 'token', companyToken
    ##.end (err, res) ->
      ##res.should.have.status 403
      ##done()

  ##it 'should apply to job if a member', (done) ->
    ##request url
    ##.post '/jobs/' + jobs[0]._id + '/apply'
    ##.set 'token', memberToken
    ##.end (err, res) ->
      ##res.should.have.status 201
      ##done()
