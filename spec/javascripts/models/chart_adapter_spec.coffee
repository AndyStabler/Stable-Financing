#= require spec_helper
#= require charting/chart_adapter

describe 'ChartAdapter', ->
  beforeEach ->
    @balanceLog = [
      {on: "1-1-2017", value: 10},
      {on: "2-1-2017", value: 15},
      {on: "3-1-2017", value: 20}
    ]
    @balanceForecast = [
      {on: "4-1-2017", value: 25},
      {on: "5-1-2017", value: 30},
      {on: "6-1-2017", value: 35}
    ]

  describe '#prependBlankBalances', ->
    it "prepends blank balances", ->
      expectedForecast = [
        {on: "1-1-2017", value: NaN},
        {on: "2-1-2017", value: NaN},
        {on: "3-1-2017", value: NaN},
        {on: "4-1-2017", value: 25},
        {on: "5-1-2017", value: 30},
        {on: "6-1-2017", value: 35}
      ]

      adapter = new StableFinancing.ChartAdapter({
        chartContainer: null,
        log: [],
        forecast: []
      })
      forecastWithBlanks = adapter.prependBlankBalances(
        @balanceLog,
        @balanceForecast
      )
      expect(forecastWithBlanks).to.deep.equal(expectedForecast)

  describe '#appendBlankBalances', ->
    it "appends blank balances", ->
      expectedLog = [
        {on: "1-1-2017", value: 10},
        {on: "2-1-2017", value: 15},
        {on: "3-1-2017", value: 20},
        {on: "4-1-2017", value: NaN},
        {on: "5-1-2017", value: NaN},
        {on: "6-1-2017", value: NaN}
      ]

      adapter = new StableFinancing.ChartAdapter({
        chartContainer: null,
        log: [],
        forecast: []
      })
      logWithBlanks = adapter.appendBlankBalances(
        @balanceLog,
        @balanceForecast
      )
      expect(logWithBlanks).to.deep.equal(expectedLog)
