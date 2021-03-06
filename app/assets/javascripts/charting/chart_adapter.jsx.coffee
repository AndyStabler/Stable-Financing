class StableFinancing.ChartAdapter

  constructor: (options) ->
    @chartContainer = options.chartContainer
    @log = options.log[..]
    @forecast = options.forecast[..]
    @fillBlankBalances()
    @selectionCallback = options.selectionCallback

  # Chart-JS requires two datasets to be of equal length for labels to work
  fillBlankBalances: ->
    logWithBlanks = @appendBlankBalances(@log, @forecast)
    forecastWithBlanks = @prependBlankBalances(@log, @forecast)
    @log = logWithBlanks
    @forecast = forecastWithBlanks

  prependBlankBalances: (blanks, balances) ->
    blankBalances = blanks.map (balance) -> { value: NaN, on: balance.on }
    blankBalances.concat(balances)

  appendBlankBalances: (balances, blanks) ->
    blankBalances = blanks.map (balance) -> { value: NaN, on: balance.on }
    balances.concat(blankBalances)

  draw: ->
    @chart = new Chart(@chartContainer, {
      type: 'line',
      data: {
        labels: (@log.concat(@forecast).map (balance) -> balance.on),
        datasets: [@balanceLogDataset(), @balanceForecastDataset()]
      },
      options: @chartOptions()
    })

  clickHandler: (callback) ->
    console.error("chart is undefined") unless @chart?
    @chartContainer.onclick = (evt) =>
      element = @chart.getElementAtEvent(evt)[0]
      return unless element?
      if element._datasetIndex == 0
        dataset = @balanceLogDataset()
      else
        dataset = @balanceForecastDataset()
      callback(dataset.data[element._index]?.x)

  balanceLogDataset: ->
    dataset = @datasetFor @log
    dataset.label = "Log £"
    dataset.backgroundColor = "rgba(205,236,251,1)"
    dataset

  balanceForecastDataset: ->
    dataset = @datasetFor @forecast
    dataset.label = "Forecast £"
    dataset.backgroundColor = "rgba(229,246,255,0.4)"
    dataset

  datasetFor: (balances) ->
    {
      lineTension: 0.1,
      backgroundColor: "rgba(112,178,210,1)",
      borderColor: "rgba(112,178,210,1)",
      borderCapStyle: 'butt',
      borderDash: [],
      borderDashOffset: 0.0,
      borderJoinStyle: 'miter',
      pointBorderColor: "rgba(75,192,192,1)",
      pointBackgroundColor: "#fff",
      pointBorderWidth: 1,
      pointHoverRadius: 5,
      pointHoverBackgroundColor: "rgba(75,192,192,1)",
      pointHoverBorderColor: "rgba(220,220,220,1)",
      pointHoverBorderWidth: 2,
      pointRadius: 0,
      pointHitRadius: 10,
      data: (balances.map (balance) -> { x: balance.on, y: balance?.value }),
      spanGaps: false,
    }

  chartOptions: ->
    {
      scales: {
        xAxes: [{
          type: 'time',
          position: 'bottom'
        }],
        yAxes: [{
          ticks: {
            callback: (value, index, values) ->
              value.toLocaleString("en-GB",{ style:"currency", currency:"GBP" })
          }
        }]
      },
      responsieve: true,
      title: {
        display: true,
        text: 'Balance log/forecast'
      },
      tooltips: {
        intersects: false,
        mode: 'label',
        position: 'nearest'
      },
      hover: {
        mode: 'single'
      }
    }
