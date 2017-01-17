class StableFinancing.BalanceDataItem
  constructor: (@dateId, @date, @balance) ->

class StableFinancing.BalanceData
  constructor: (@jsonData) ->
    @balanceLog = $.map @jsonData[0], logFromJson
    @balanceForecast = $.map @jsonData[1], logFromJson

  logFromJson = (balance) ->
    balanceDate = balance.on.toString().split(" ").slice(0,4).join(" ")
    new StableFinancing.BalanceDataItem(
      new Date(balanceDate).toString(),
      new Date(balanceDate),
      parseFloat(balance.value)
    )

StableFinancing.fetchBalanceData = (options) ->
  $.ajax({
    url: $(".user-data").data("json-url")
    cache: false,
    dataType: "json"
  })
  .done (response) ->
    StableFinancing.balanceData = new StableFinancing.BalanceData(response)
    options.success?()
  .fail (response) -> options.fail?()

StableFinancing.fetchTransfers = (options) ->
  $.getJSON(
    $(".user-data").data("transfers-url"),
    { format: "json" })
  .done((response) ->
    StableFinancing.transfers = response
    options.success?())
  .fail -> options.fail?()

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

StableFinancing.drawChart = ->
  new StableFinancing.GoogleChart({
      chartContainer: document.getElementById('balance-data'),
      log: StableFinancing.balanceData.balanceLog,
      forecast: StableFinancing.balanceData.balanceForecast
      selectionCallback: StableFinancing.balanceItemSelected
    }).startDrawing();

StableFinancing.handleFailedBalancesFetch = ->
  $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>")

StableFinancing.handleFailedTransfersFetch = ->
  $("#balance-data").html("<h1>Eeep! We had trouble getting your balance data 😿</h1>")

$(document).on 'ready page:load', ->
  StableFinancing.fetchTransfers(
    fail: StableFinancing.handleFailedTransfersFetch)
  $("#user-transfer-new-button").click( ->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  StableFinancing.initialiseDatePicker()
  ReactDOM.render(`<Loading />`, $("#balance-data")[0])
  StableFinancing.fetchBalanceData(
    success: StableFinancing.drawChart,
    fail: StableFinancing.handleFailedBalancedFetch
    )
