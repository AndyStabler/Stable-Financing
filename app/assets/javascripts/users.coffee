# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  document.getElementById('options-in').addEventListener("click", ->
    document.getElementById("user-transfers-in").style.display = "block"
    document.getElementById("user-transfers-out").style.display = "none"
    document.getElementById("options-in").className = "selected"
    document.getElementById("options-out").className = "unselected")
  document.getElementById('options-out').addEventListener("click", ->
    document.getElementById("user-transfers-in").style.display = "none"
    document.getElementById("user-transfers-out").style.display = "block"
    document.getElementById("options-in").className = "unselected"
    document.getElementById("options-out").className = "selected")
  $("#user-transfer-new-button").click(->
    $("#new_transfer").toggle()
    $("#user-transfer-new-button").toggleClass("closed open"))
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())