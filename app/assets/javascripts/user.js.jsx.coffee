class StableFinancing.Views.Users.Show

  @drawChart: (balances) ->
    chartAdapter = new StableFinancing.ChartAdapter({
        chartContainer: document.getElementById('balance-data'),
        log: balances.log,
        forecast: balances.forecast
      })
    chart = chartAdapter.draw()
    chartAdapter.clickHandler (element) ->
      $.ajax({
        url: $(".user-data").data("balance-forecast-url"),
        data: { date: element },
      })
      .done (html) ->
        $("#balance_forecast").replaceWith(html)

$(document).on 'turbolinks:load', ->
  return unless $(".users.show").length > 0

  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))

  StableFinancing.initialiseDatePicker()
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  StableFinancing.Models.Balance.fetchAll
    balancesUrl: $(".user-data").data("balances-url")
    success: StableFinancing.Views.Users.Show.drawChart
    fail: -> $("#balance-data").html("<h1>Couldn't get balance data</h1>")
