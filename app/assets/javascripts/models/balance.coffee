class StableFinancing.Balance
  constructor: (@on, @value) ->

  @createFromJson: (balanceJSON) ->
    balance = JSON.parse(balanceJSON)
    new StableFinancing.Balance(
      Date.parseRailsDate(balance.on),
      parseFloat(balance.value)
    )
