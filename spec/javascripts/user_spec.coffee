#= require spec_helper
#= require components/balance_data
#= require models/balance
#= require user

fixture.preload('users/show')

describe 'Users.Show', ->

  beforeEach ->
    this.fixtures = fixture.load('users/show.html')
    @server = sinon.fakeServer.create()
    @success = sinon.spy()

  afterEach ->
    @server.restore()

  describe '.fetchTransfers', ->
    it 'correctly handles success', ->
      response = [200, { 'Content-Type': 'application/json' }, JSON.stringify('Success!')]
      @server.respondWith('GET', '/transfers/1.json', response)
      StableFinancing.Views.Users.Show.fetchTransfers(success: @success)
      @server.respond()

      expect(@success).to.have.been.calledWith('Success!')
      expect($("#selected-balance-info").html()).to.not.equal("<h1>Couldn't get transfers</h1>")

    it 'correctly handles failure', ->
      response = [500, { 'Content-Type': 'application/json' }, JSON.stringify('Error!')]
      @server.respondWith('GET', '/transfers/1.json', response)

      StableFinancing.Views.Users.Show.fetchTransfers(success: @success)
      @server.respond()

      expect(@success).to.not.have.been.called
      expect($("#selected-balance-info").html()).to.equal("<h1>Couldn't get transfers</h1>")
