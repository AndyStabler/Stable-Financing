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
      debugger
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

  describe '.fetchBalances', ->
    it 'correctly handles success', ->
      log = [
        {on: '2016-12-04T00:00:00.000Z', value: '50.01'},
        {on: '2016-12-05T00:00:00.000Z', value: '12.50'}
      ]
      forecast = [
        {on: '2017-01-04T00:00:00.000Z', value: '100.23'},
        {on: '2017-01-05T00:00:00.000Z', value: '70'}
      ]

      body = [log, forecast]
      response = [200, { 'Content-Type': 'application/json' }, JSON.stringify(body)]
      @server.respondWith('GET', '/balances/1.json', response)

      StableFinancing.Views.Users.Show.fetchBalances(success: @success)
      @server.respond()

      balanceLog = [
        new StableFinancing.Models.Balance('2016-12-04T00:00:00.000Z', '50.01'),
        new StableFinancing.Models.Balance('2016-12-05T00:00:00.000Z', '12.50')
      ]
      forecastLog = [
        new StableFinancing.Models.Balance('2017-01-04T00:00:00.000Z', '100.23'),
        new StableFinancing.Models.Balance('2017-01-05T00:00:00.000Z', '70')
      ]
      expect(@success).to.have.been.calledWith({log: balanceLog, forecast: forecastLog})
      expect($("#balance-data").html()).to.not.equal("<h1>Couldn't get balance data</h1>")

    it 'correctly handles failure', ->
      response = [500, { 'Content-Type': 'application/json' }, JSON.stringify('Error!')]
      @server.respondWith('GET', '/balances/1.json', response)

      StableFinancing.Views.Users.Show.fetchBalances(success: @success)
      @server.respond()

      expect(@success).to.not.have.been.called
      expect($("#balance-data").html()).to.equal("<h1>Couldn't get balance data</h1>")
