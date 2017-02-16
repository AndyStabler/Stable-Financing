class StableFinancing.Models.Transfer
  @fetchTransfers: (options) ->
    $.getJSON(options.transferUrl, { transfer_date: options.date })
    .done((response) ->
      options.success(response))
    .fail (response) -> options.fail(response)
