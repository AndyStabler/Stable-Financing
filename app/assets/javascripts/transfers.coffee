# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

StableFinancing.initialiseNewTransferToggle = () ->
  $('#new-transfer-toggle').click ->
    $("#new-transfer-container").slideToggle 500, ->
      $('#new-transfer-toggle').find('i').toggleClass('glyphicon-minus').toggleClass('glyphicon-plus')

$(document).on 'ready page:load', ->
  StableFinancing.initialiseNewTransferToggle()
