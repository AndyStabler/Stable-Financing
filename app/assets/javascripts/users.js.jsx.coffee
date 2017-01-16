# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Date.prototype.toString = () ->
  this.getDate() + "-" + (this.getMonth() + 1) + "-" + this.getFullYear()

class StableFinancing.BalanceDataItem
  constructor: (@dateId, @date, @balance) ->

class StableFinancing.BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      new StableFinancing.BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(balance.value)
      )
    @balanceForecast = $.map @jsonData[1], (forecast) ->
      balanceDate = forecast.on.toString().split(" ").slice(0,4).join(" ")
      new StableFinancing.BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(forecast.value)
      )

StableFinancing.fetchBalanceData = (success_callback) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done((response) ->
    StableFinancing.balanceData = new StableFinancing.BalanceData(response)
    success_callback())
  .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

StableFinancing.getTransfers = () ->
  $.getJSON(
    $(".user-data").data("transfers-url"),
    { format: "json" })
  .done((response) ->
    StableFinancing.transfers = response)
  .fail(() -> console.log("Eeep! We had trouble getting the transfers 😿"))

StableFinancing.createTableFrom = (log, label) ->
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn('date', 'Date')
  dataTable.addColumn('number', label)
  dataTable.addRows($.map(log, (item) -> [[item.date, item.balance]]))
  dataTable

StableFinancing.drawChart = () ->
  StableFinancing.balanceData.balanceForecast.unshift(StableFinancing.balanceData.balanceLog[..].pop())
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

  # create the data tables
  balanceDataTable = StableFinancing.createTableFrom(StableFinancing.balanceData.balanceLog, "Balance")
  forecastDataTable = StableFinancing.createTableFrom(StableFinancing.balanceData.balanceForecast, "Forecast")
  joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
  chart.draw(joinedData, options)
  google.visualization.events.addListener(chart, 'select', () -> StableFinancing.chartSelectHandler(chart.getSelection()[0], joinedData));

StableFinancing.drawChartProxy = () ->
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  StableFinancing.fetchBalanceData () -> StableFinancing.drawChart()

StableFinancing.chartSelectHandler = (selection, data) ->
  # The user selected _all_ the items
  if !selection || !selection.row
    return
  date = data.getValue(selection.row, 0).toString()
  StableFinancing.balanceItemSelected(date)

StableFinancing.balanceItemSelected = (dateId) ->
  StableFinancing.selectedDate = dateId;
  selectedForecast = StableFinancing.balanceData.balanceForecast.find((dataItem) -> dataItem.dateId == dateId)
  if !selectedForecast
    return
  transfers = StableFinancing.transfers.filter((transfer) -> new Date(transfer.on).toString() == dateId)
  $.getJSON(
    $(".user-data").data("transfers-url"),
    {
      format: "json",
      transfer: selectedForecast.dateId
    })
  .done((response) ->
    ReactDOM.render(`<Transfers transfers={response} />`, $("#selected-balance-info")[0]))
  .fail(() -> console.log("FAIL"))

$(document).on 'ready page:load', ->
  StableFinancing.getTransfers()
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  StableFinancing.initialiseDatePicker()
  if google?
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})
    google.charts.setOnLoadCallback () -> StableFinancing.drawChartProxy()
  else
    console.log("Google is dead")

