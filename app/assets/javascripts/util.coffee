Date.prototype.toString = () ->
  [this.getDate(), this.getMonth(), this.getFullYear()].join('-')

Date.parseRailsDate = (dateString) ->
  dateChunks = dateString.split(' ')
  date = dateChunks[0].split('-')
  time = dateChunks[1].split(':')

  year = date[0]
  month = date[1]
  day = date[2]

  hour = time[0]
  minute = time[1]
  second = time[2]

  new Date(Date.UTC(year, month, day, hour, minute, second))

StableFinancing.initialiseDatePicker = () ->
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
  }).datepicker('setDate', new Date())
