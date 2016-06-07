initNewTransfer = () ->
  console.log("in init new transfer")
  $("#new-transfer-container").replaceWith("<%= escape_javascript(render 'new_transfer_form', :transfer => @transfer) %>");
  $("#new-transfer-toggle").replaceWith("<%= escape_javascript(render 'new_transfer_toggle', :transfer => @transfer) %>");
  sfUser.initialiseNewTransferToggle()
  sfUser.initialiseDatePicker()


<% if @transfer.errors.present? %>
console.log("transfer has errors")
initNewTransfer()
<% else %>
$("#new-transfer-container").addClass("bg-success")
setTimeout(() ->
  $("#new-transfer-container").removeClass("bg-success");
  initNewTransfer()
, 500)
$("#transfers-list").replaceWith("<%= escape_javascript(render 'transfers_list', :user => @transfer.user) %>");
ReactRailsUJS.mountComponents("#user-transfers-in")
ReactRailsUJS.mountComponents("#user-transfers-out")
sfUser.initialiseOptionsIn()
sfUser.initialiseOptionsOut()
sfUser.drawChartOrFallbackTable()
<% end %>
