window.StableFinancing = {};

StableFinancing.initialiseDatePicker = () ->
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())
