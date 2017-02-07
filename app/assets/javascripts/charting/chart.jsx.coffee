class StableFinancing.Chart

  constructor: (options) ->
    @chartContainer = options.chartContainer
    @log = options.log[..]
    @forecast = options.forecast[..]
    [..., lastLog] = @log
    @forecast.unshift(lastLog)
    @selectionCallback = options.selectionCallback

  startDrawing: ->
    console.log("Inside of startDrawing!")
    return console.error("Google Charts unavailable") unless google?
    console.log("Google is defined!")
    google.charts.load('current', {'packages':['corechart']})
    google.charts.setOnLoadCallback () => @draw()

  draw: ->
    return console.error("Google Charts unavailable") unless google?
    console.log("Inside of draw!")
    # create the data tables
    balanceDataTable = @createTableFrom(@log, "Balance")
    forecastDataTable = @createTableFrom(@forecast, "Forecast")
    joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
    console.log("chart is _not_ defined!")
    # Instantiate and draw our chart, passing in some options.
    chart = new google.visualization.AreaChart(@chartContainer)
    console.log("chart is defined!")
    chart.draw(joinedData, options)
    #google.visualization.events.addListener(chart, 'select', () => @chartSelectHandler(chart.getSelection()[0], joinedData));

  createTableFrom: (balanceItems, label) ->
    dataTable = new google.visualization.DataTable()
    dataTable.addColumn('date', 'Date')
    dataTable.addColumn('number', label)
    dataTable.addRows($.map(balanceItems, (item) -> [[item.on, item.value]]))
    dataTable

  chartSelectHandler: (selection, data) ->
    # The user selected _all_ the items
    return if !selection || !selection.row
    date = data.getValue(selection.row, 0).toString()
    @selectionCallback(date)

  options = explorer:
    actions: ['dragToZoom', 'rightClickToReset']
    keepInBounds: true,
    colors: ['#b3d7ed', '#0079c1']
    legend:
      position: "bottom"
    vAxis:
      gridlineColor: 'transparent'
      baselineColor: '#868686'
    hAxis:
      gridlineColor: 'transparent'
      baselineColor: '#868686'
