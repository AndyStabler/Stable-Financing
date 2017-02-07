class StableFinancing.Models.Balance
  constructor: (@on, @value) ->
    @on = new Date(@on) if typeof @on is 'string'
    @value = parseFloat(@value) if typeof @value is 'string'
