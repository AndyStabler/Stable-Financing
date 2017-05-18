class StableFinancing.ChartAdapter

  constructor: (options) ->
    @chartContainer = options.chartContainer
    @log = options.log[..]
    @forecast = options.forecast[..]
    @selectionCallback = options.selectionCallback

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
      callback(dataset.data[element._index].x)

  balanceLogDataset: ->
    dataset = @datasetFor @log
    dataset.label = "Log £"
    dataset.backgroundColor = "rgba(75,192,192,0.4)"
    dataset

  balanceForecastDataset: ->
    dataset = @datasetFor @forecast
    dataset.label = "Forecast £"
    dataset.backgroundColor = "rgba(229,246,255,0.4)"
    dataset

  datasetFor: (balances) ->
    {
      lineTension: 0.1,
      backgroundColor: "rgba(229,246,255,0.4)",
      borderColor: "rgba(75,192,192,1)",
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
      data: (balances.map (balance) -> { x: balance.on, y: balance.value }),
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
        intersects: false
      },
      hover: {
        mode: 'single'
      }
    }
