# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
  $("#user-transfer-new-button").click(->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())

  getBalanceData = ->
    $.ajax({
      url: $(".user-data").data("json-url")
      # url: "<%# user_path @user %>.json",
      cache: false,
      dataType: "json"
    })
    .done((response) -> if show_chart then drawChart(response) else $("#balance-data").html(response))
    .fail((response) -> $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>"))

  drawChart = (response) ->
    jsonData = response
    balanceLog = $.map jsonData[0], (balance) ->
      balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
      [[new Date(balanceDate), parseFloat(balance.value)]]
    balanceForecast = $.map jsonData[1], (forecast) ->
      transfers = "some transfer"
      [[new Date(forecast.date), parseFloat(forecast.balance)]]
    console.log("balanceLog is " + balanceLog)
    [..., last] = balanceLog
    balanceForecast.unshift(last)
    # Create the data table.
    balanceData = new google.visualization.DataTable()
    balanceData.addColumn('date', 'Date')
    balanceData.addColumn('number', 'Balance')
    balanceData.addRows(balanceLog)
    # Create the data table.
    forecastData = new google.visualization.DataTable()
    forecastData.addColumn('date', 'Date')
    forecastData.addColumn('number', 'Forecast')
    forecastData.addRows(balanceForecast)
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
    joinedData = google.visualization.data.join(forecastData, balanceData, 'full', [[0, 0]], [1], [1])
    # Instantiate and draw our chart, passing in some options.
    chart = new google.visualization.AreaChart(document.getElementById('balance-data'))
    chart.draw(joinedData, options)


  console.log("google? " + google?)
  console.log("getBalanceData()? " + getBalanceData?)
  show_chart = google?
  if show_chart
    # Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart']})

    # Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback(getBalanceData)
  else
    getBalanceData()
