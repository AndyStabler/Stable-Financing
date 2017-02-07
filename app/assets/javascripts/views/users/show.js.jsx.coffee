class StableFinancing.Views.Users.Show

  @fetchTransfers: (options) ->
    $.getJSON($(".user-data").data("transfers-url"), { transfer_date: options.date })
    .done((response) ->
      options.success(response))
    .fail (response) ->
      $("#selected-balance-info").html("<h1>Couldn't get transfers</h1>")

  @fetchBalances: (options) ->
    $.getJSON($(".user-data").data("json-url"))
    .done((response) ->
      options.success(
        log: ($.map response[0], (balance) ->
          new StableFinancing.Models.Balance(balance.on, balance.value)),
        forecast: ($.map response[1], (balance) ->
          new StableFinancing.Models.Balance(balance.on, balance.value))
      ))
    .fail (response) ->
      $("#balance-data").html("<h1>Couldn't get balance data</h1>")

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
  StableFinancing.Views.Users.Show.fetchBalances(success: StableFinancing.Views.Users.Show.drawChart)
