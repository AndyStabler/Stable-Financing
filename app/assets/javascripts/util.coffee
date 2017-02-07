Date.prototype.toString = () ->
  [this.getDate(), this.getMonth() + 1, this.getFullYear()].join('-')

StableFinancing.initialiseDatePicker = () ->
  return unless $('.datepicker').length
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())
