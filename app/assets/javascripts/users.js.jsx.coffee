# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Date.prototype.toString = () ->
  this.getDate() + "-" + (this.getMonth() + 1) + "-" + this.getFullYear()

class stableFinancing.BalanceDataItem
  constructor: (@dateId, @date, @balance) ->

class stableFinancing.BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      new stableFinancing.BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(balance.value)
      )
    @balanceForecast = $.map @jsonData[1], (forecast) ->
      balanceDate = forecast.on.toString().split(" ").slice(0,4).join(" ")
      new stableFinancing.BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(forecast.value)
      )

stableFinancing.fetchBalanceData = (success_callback) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done((response) ->
    stableFinancing.balanceData = new stableFinancing.BalanceData(response)
    success_callback())
  .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

stableFinancing.getTransfers = () ->
  $.getJSON(
    $(".user-data").data("transfers-url"),
    { format: "json" })
  .done((response) ->
    stableFinancing.transfers = response)
  .fail(() -> console.log("Eeep! We had trouble getting the transfers 😿"))

stableFinancing.createTableFrom = (log, label) ->
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn('date', 'Date')
  dataTable.addColumn('number', label)
  dataTable.addRows($.map(log, (item) -> [[item.date, item.balance]]))
  dataTable

stableFinancing.drawChart = () ->
  stableFinancing.balanceData.balanceForecast.unshift(stableFinancing.balanceData.balanceLog[..].pop())
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
  balanceDataTable = stableFinancing.createTableFrom(stableFinancing.balanceData.balanceLog, "Balance")
  forecastDataTable = stableFinancing.createTableFrom(stableFinancing.balanceData.balanceForecast, "Forecast")
  joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
  chart.draw(joinedData, options)
  google.visualization.events.addListener(chart, 'select', () -> stableFinancing.chartSelectHandler(chart.getSelection()[0], joinedData));

stableFinancing.drawChartProxy = () ->
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  stableFinancing.fetchBalanceData () -> stableFinancing.drawChart()

stableFinancing.chartSelectHandler = (selection, data) ->
  # The user selected _all_ the items
  if !selection || !selection.row
    return
  date = data.getValue(selection.row, 0).toString()
  stableFinancing.balanceItemSelected(date)

stableFinancing.balanceItemSelected = (dateId) ->
  stableFinancing.selectedDate = dateId;
  selectedForecast = stableFinancing.balanceData.balanceForecast.find((dataItem) -> dataItem.dateId == dateId)
  if !selectedForecast
    return
  transfers = stableFinancing.transfers.filter((transfer) -> new Date(transfer.on).toString() == dateId)
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
  stableFinancing.getTransfers()
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  stableFinancing.initialiseDatePicker()
  if google?
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})
    # stableFinancing.getBalanceData () -> stableFinancing.drawChart()
    google.charts.setOnLoadCallback () -> stableFinancing.drawChartProxy()
    # google.charts.setOnLoadCallback(() -> (stableFinancing.fetchBalanceData () -> stableFinancing.drawChartProxy()));
  else
    console.log("Google is dead")

