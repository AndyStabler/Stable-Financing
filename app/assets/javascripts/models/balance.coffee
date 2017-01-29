class StableFinancing.Models.Balance
  constructor: (@on, @value) ->

  @createFromJson: (balanceJSON) ->
    balance = JSON.parse(balanceJSON)
    new StableFinancing.Models.Balance(
      Date.parseRailsDate(balance.on),
      parseFloat(balance.value)
    )
