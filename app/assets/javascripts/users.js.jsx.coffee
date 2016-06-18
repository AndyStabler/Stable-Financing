# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.sfUser = window.sfUser || {}

Date.prototype.toString = () ->
  this.getDate() + "-" + (this.getMonth() + 1) + "-" + this.getFullYear()

class sfUser.BalanceDataItem
  constructor: (@dateId, @date, @balance) ->

class sfUser.BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      new sfUser.BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(balance.value)
      )
    @balanceForecast = $.map @jsonData[1], (forecast) ->
      new sfUser.BalanceDataItem(
        new Date(forecast.date).toString(),
        new Date(forecast.date),
        parseFloat(forecast.balance)
      )

sfUser.getBalanceData = (success_callback) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done((response) ->
    sfUser.balanceData = new sfUser.BalanceData(response)
    success_callback())
  .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

sfUser.getTransfers = () ->
  $.getJSON(
    $(".user-data").data("transfers-url"),
    { format: "json" })
  .done((response) ->
    sfUser.transfers = response)
  .fail(() -> console.log("Eeep! We had trouble getting the transfers 😿"))

sfUser.createTableFrom = (log, label) ->
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn('date', 'Date')
  dataTable.addColumn('number', label)
  dataTable.addRows($.map(log, (item) -> [[item.date, item.balance]]))
  dataTable

sfUser.drawChart = () ->
  sfUser.balanceData.balanceForecast.unshift(sfUser.balanceData.balanceLog[..].pop())
  options =
    explorer:
      actions: ['dragToZoom', 'rightClickToReset']
      keepInBounds: true,
      colors: ['#e0440e', '#e6693e', '#ec8f6e', '#f3b49f', '#f6c7b6']
    series:
      0:
        lineWidth: 2
    curveType: 'function'
    pointSize: 2
    colors: ['#e0440e', '#15A0C8']
    legend:
      position: "bottom"
  # create the data tables
  balanceDataTable = sfUser.createTableFrom(sfUser.balanceData.balanceLog, "Balance")
  forecastDataTable = sfUser.createTableFrom(sfUser.balanceData.balanceForecast, "Forecast")
  joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
  chart.draw(joinedData, options)
  google.visualization.events.addListener(chart, 'select', () -> sfUser.chartSelectHandler(chart.getSelection()[0], joinedData));
  google.visualization.events.addListener(chart, 'onmouseover', (e) -> sfUser.chartSelectHandler(e, joinedData));

sfUser.drawChartOrFallbackTable = () ->
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  if google?
    sfUser.getBalanceData () -> sfUser.drawChart()
  else
    sfUser.getBalanceData () -> sfUser.drawTable()

sfUser.chartSelectHandler = (selection, data) ->
  # The user selected _all_ the items
  if !selection || !selection.row
    return
  date = data.getValue(selection.row, 0).toString()
  sfUser.balanceItemSelected(date)

sfUser.drawTable = () ->
  names = ["Date", "Balance"]
  ReactDOM.render(`<BalanceTable balanceData={sfUser.balanceData}/>`, $("#balance-data")[0])

sfUser.balanceItemSelected = (dateId) ->
  selectedForecast = sfUser.balanceData.balanceForecast.find((dataItem) -> dataItem.dateId == dateId)
  if !selectedForecast
    return
  transfers = sfUser.transfers.filter((transfer) -> new Date(transfer.on).toString() == dateId)
  $.getJSON(
    $(".user-data").data("transfers-url"),
    {
      format: "json",
      transfer: selectedForecast.dateId
    })
  .done((response) ->
    ReactDOM.render(`<Transfers transfers={response} />`, $("#selected-balance-info")[0]))
  .fail(() -> console.log("FAIL"))

sfUser.initialiseDatePicker = () ->
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())

$(document).on 'ready page:load', ->
  sfUser.getTransfers()
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  sfUser.initialiseDatePicker()
  $(document).on('mouseover', '.balance-table-row', (event) ->
    balanceItemSelected(event.currentTarget.attributes["data-date-id"].value))
  if google?
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})
    google.charts.setOnLoadCallback(sfUser.drawChartOrFallbackTable);
  else
    sfUser.drawChartOrFallbackTable()

