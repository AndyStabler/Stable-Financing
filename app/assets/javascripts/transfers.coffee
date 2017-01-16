StableFinancing.initialiseNewTransferToggle = () ->
  $('#new-transfer-toggle').click ->
    $("#new-transfer-container").slideToggle 500, ->
      $('#new-transfer-toggle').find('i').toggleClass('glyphicon-minus').toggleClass('glyphicon-plus')

$(document).on 'ready page:load', ->
  StableFinancing.initialiseNewTransferToggle()
