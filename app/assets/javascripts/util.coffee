Date.prototype.toString = () ->
  [this.getDate(), this.getMonth(), this.getFullYear()].join('-')

StableFinancing.initialiseDatePicker = () ->
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())
