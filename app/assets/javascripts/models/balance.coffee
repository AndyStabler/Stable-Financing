class StableFinancing.Models.Balance
  constructor: (@on, @value) ->
    @on = new Date(@on) if typeof @on is 'string'
    @value = parseFloat(@value) if typeof @value is 'string'

  @fetchAll: (options) ->
    $.getJSON(options.balanceUrl)
    .done((response) ->
      options.success(
        log: ($.map response[0], (balance) ->
          new StableFinancing.Models.Balance(balance.on, balance.value)),
        forecast: ($.map response[1], (balance) ->
          new StableFinancing.Models.Balance(balance.on, balance.value))
      ))
    .fail (response) -> options.fail(response)
