# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      [[new Date(balanceDate), parseFloat(balance.value)]]
    @balanceForecast = $.map @jsonData[1], (forecast) ->
      [[new Date(forecast.date), parseFloat(forecast.balance)]]
    @balanceForecast.unshift(@balanceLog[..].pop())

getBalanceData = (success_callback) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done((response) -> success_callback(new BalanceData(response)))
  .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

createTableFrom = (log, label) ->
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn('date', 'Date')
  dataTable.addColumn('number', label)
  dataTable.addRows(log)
  dataTable

drawChart = (balanceData) ->
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
  balanceDataTable = createTableFrom(balanceData.balanceLog, "Balance")
  forecastDataTable = createTableFrom(balanceData.balanceForecast, "Forecast")
  joinedData = google.visualization.data.join(forecastDataTable, balanceDataTable, 'full', [[0, 0]], [1], [1])
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
  chart.draw(joinedData, options)

drawTable = (balanceData) ->
  $("#balance-data").html(balanceData.jsonData)

$(document).on 'ready page:load', ->
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

  if google?
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})
    # Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback ->
      getBalanceData (balanceData) -> drawChart(balanceData)
  else
    getBalanceData (balanceData) -> drawTable(balanceData)
