class StableFinancing.Views.Users.Show

  @fetchTransfers: (options) ->
    $.getJSON($(".user-data").data("transfers-url"), { transfer_date: options.date })
    .done((response) ->
      options.success(response))
    .fail (response) ->
      $("#selected-balance-info").html("<h1>Couldn't get transfers</h1>")

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
  StableFinancing.Models.Balance.fetchBalances
    balanceUrl: $(".user-data").data("json-url")
    success: StableFinancing.Views.Users.Show.drawChart
    fail: $("#balance-data").html("<h1>Couldn't get balance data</h1>")
