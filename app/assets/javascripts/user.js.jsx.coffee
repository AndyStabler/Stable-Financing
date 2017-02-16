class StableFinancing.Views.Users.Show

  @drawChart: (balances) ->
    new StableFinancing.Chart({
        chartContainer: document.getElementById('balance-data'),
        log: balances.log,
        forecast: balances.forecast
      }).startDrawing();

$(document).on 'turbolinks:load', ->
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  StableFinancing.initialiseDatePicker()
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  StableFinancing.Models.Balance.fetchAll
    balanceUrl: $(".user-data").data("json-url")
    success: StableFinancing.Views.Users.Show.drawChart
    fail: $("#balance-data").html("<h1>Couldn't get balance data</h1>")
