#= require spec_helper
#= require models/transfer

describe 'Transfer', ->
  describe '.fetchTransfers', ->

    beforeEach ->
      @server = sinon.fakeServer.create()
      @success = sinon.spy()
      @failure = sinon.spy()

    it 'correctly handles success', ->
      response = [
        200, {
        'Content-Type': 'application/json' },
        JSON.stringify('Success!')
      ]
      @server.respondWith('GET', '/transfers/1.json', response)
      StableFinancing.Models.Transfer.fetchTransfers(
        transferUrl: '/transfers/1.json',
        success: @success,
        fail: @failure
      )
      @server.respond()

      expect(@success).to.have.been.calledWith('Success!')
      expect(@failure).to.not.have.been.called

    it 'correctly handles failure', ->
      response = [
        500,
        { 'Content-Type': 'application/json' },
        JSON.stringify('Error!')
      ]
      @server.respondWith('GET', '/transfers/1.json', response)

      StableFinancing.Models.Transfer.fetchTransfers(
        transferUrl: '/transfers/1.json',
        success: @success,
        fail: @failure
      )
      @server.respond()

      expect(@success).to.not.have.been.called
      expect(@failure).to.have.been.called
