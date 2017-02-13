#= require spec_helper
#= require models/balance

describe 'Balance', ->
  it 'constructs the object when the arguments are strings', ->
    date = "2016-12-04T00:00:00.000Z"
    balance = new StableFinancing.Models.Balance(date, "50.20")
    expect(balance.on.getTime()).to.equal(new Date(date).getTime())
    expect(balance.value).to.equal(50.20)

  it 'constructs the object', ->
    date = new Date("2016-12-04T00:00:00.000Z")
    balance = new StableFinancing.Models.Balance(date, 50.20)
    expect(balance.on.getTime()).to.equal(date.getTime())
    expect(balance.value).to.equal(50.20)


  describe '.fetchBalances', ->
    beforeEach ->
      fixture.load('users/show')
      @server = sinon.fakeServer.create()
      @success = sinon.spy()
      @failure = sinon.spy()

    afterEach ->
      @server.restore()

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

      StableFinancing.Models.Balance.fetchBalances(
        success: @success
        fail: @failure)
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
      expect(@failure).to.not.have.been.called

    it 'correctly handles failure', ->
      response = [500, { 'Content-Type': 'application/json' }, JSON.stringify('Error!')]
      @server.respondWith('GET', '/balances/1.json', response)

      StableFinancing.Models.Balance.fetchBalances(
        success: @success
        fail: @failure)
      @server.respond()

      expect(@success).to.not.have.been.called
      expect(@failure).to.have.been.calledWith
