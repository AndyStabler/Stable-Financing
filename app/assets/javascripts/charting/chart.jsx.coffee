class StableFinancing.ChartAdapter

  constructor: (options) ->
    @chartContainer = options.chartContainer
    @log = options.log[..]
    @forecast = options.forecast[..]
    @selectionCallback = options.selectionCallback

  draw: ->
    new Chart(@chartContainer, {
      type: 'line',
      data: {
        labels: (@log.concat(@forecast).map (balance) -> balance.on),
        datasets: [
            {
                label: "Log £",
                lineTension: 0.1,
                backgroundColor: "rgba(75,192,192,0.4)",
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
                pointRadius: 1,
                pointHitRadius: 10,
                data: (@log.map (balance) -> { x: balance.on, y: balance.value }),
                spanGaps: false,
            },
            {
                label: "Forecast £",
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
                pointRadius: 1,
                pointHitRadius: 10,
                data: (@forecast.map (balance) -> { x: balance.on, y: balance.value }),
                spanGaps: false,
            }
        ]
      },
      options: {
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
  })
