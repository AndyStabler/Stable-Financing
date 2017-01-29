#= require spec_helper
#= require models/balance

describe 'Balance', ->
  describe '.createFromJson', ->
    it 'creates a balance object', ->
      balanceJSON = JSON.stringify(
        on: '2017-01-15 20:57:13 UTC',
        value: 50.50
      )
      balance = StableFinancing.Models.Balance.createFromJson(balanceJSON)
      expectedDate = Date.parseRailsDate('2017-01-15 20:57:13 UTC')
      expect(balance.on.getTime()).to.equal(expectedDate.getTime())
      expect(balance.value).to.equal(50.50)
