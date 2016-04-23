# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Date.prototype.toString = () ->
  this.getDate() + "-" + (this.getMonth() + 1) + "-" + this.getFullYear()

class BalanceDataItem
  constructor: (@dateId, @date, @balance) ->

class BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      new BalanceDataItem(
        new Date(balanceDate).toString(),
        new Date(balanceDate),
        parseFloat(balance.value)
      )
    @balanceForecast = $.map @jsonData[1], (forecast) ->
      new BalanceDataItem(
        new Date(forecast.date).toString(),
        new Date(forecast.date),
        parseFloat(forecast.balance)
      )

getBalanceData = (success_callback) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done((response) ->
    sfUser.balanceData = new BalanceData(response)
    success_callback())
  .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

getTransfers = () ->
  $.getJSON(
    $(".user-data").data("transfers-url"),
    { format: "json" })
  .done((response) ->
    sfUser.transfers = response)
  .fail(() -> console.log("Eeep! We had trouble getting the transfers 😿"))

createTableFrom = (log, label) ->
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn('date', 'Date')
  dataTable.addColumn('number', label)
  dataTable.addRows($.map(log, (item) -> [[item.date, item.balance]]))
  dataTable

drawChart = () ->
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
  balanceDataTable = createTableFrom(sfUser.balanceData.balanceLog, "Balance")
  forecastDataTable = createTableFrom(sfUser.balanceData.balanceForecast, "Forecast")
  joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
  chart.draw(joinedData, options)

drawTable = () ->
  names = ["Date", "Balance"]
  ReactDOM.render(`<BalanceTable balanceData={sfUser.balanceData}/>`, $("#balance-data")[0])

balanceItemSelected = (dateId) ->
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

$(document).on 'ready page:load', ->
  window.sfUser = window.sfUser || {}
  getTransfers()
  document.getElementById('options-in').addEventListener("click", ->
    document.getElementById("user-transfers-in").style.display = "block"
    document.getElementById("user-transfers-out").style.display = "none"
    document.getElementById("options-in").className = "selected"
    document.getElementById("options-out").className = "unselected")
  document.getElementById('options-out').addEventListener("click", ->
    document.getElementById("user-transfers-in").style.display = "none"
    document.getElementById("user-transfers-out").style.display = "block"
    document.getElementById("options-in").className = "unselected"
    document.getElementById("options-out").className = "selected")
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())
  $(document).on('mouseover', '.balance-table-row', (event) ->
    balanceItemSelected(event.currentTarget.attributes["data-date-id"].value))

  if google?
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})
    # Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback ->
      getBalanceData () -> drawChart()
  else
    getBalanceData () -> drawTable()
