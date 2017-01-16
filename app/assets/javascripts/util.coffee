Date.prototype.toString = () ->
  [this.getDate(), this.getMonth(), this.getFullYear()].join('-')
